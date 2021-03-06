//
//  MealManager.m
//  Mission Health
//
//  Created by Connor Krupp on 2/9/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

@import Realm;

#import "MealManager.h"
#import "APIManager.h"
#import "MHServing.h"
#import "MHDay.h"

@interface MealManager ()

@property (strong, nonatomic) MHDay *day;

@property (strong, nonatomic) NSString *apiConsumerKey;
@property (strong, nonatomic) NSString *apiConsumerSecret;

@property (nonatomic) double calories;
@property (nonatomic) double fat;
@property (nonatomic) double carbs;
@property (nonatomic) double protein;

@end

@implementation MealManager

- (instancetype)init {
    return [self initWithDate:[NSDate date]];
}

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super init]) {
        self.date = [[NSCalendar currentCalendar] startOfDayForDate:date];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"date = %@", self.date];
        RLMResults<MHDay *> *days = [MHDay objectsWithPredicate:pred];
        
        NSAssert(days.count <= 1, @"There should never be two days with the same date");
        
        if (days.count == 0) {
            MHDay *day = [[MHDay alloc] initWithDate:self.date];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm transactionWithBlock:^{
                [realm addObject:day];
            }];
            
            self.day = day;
        } else {
            self.day = days[0];
        }
        
        NSString *configurationPath = [[NSBundle mainBundle] pathForResource:@"configuration" ofType:@"plist"];
        NSDictionary *configuration = [NSDictionary dictionaryWithContentsOfFile:configurationPath];
        self.apiConsumerKey = configuration[@"fatsecret-consumer-key"];
        self.apiConsumerSecret = configuration[@"fatsecret-consumer-secret"];
    }
    
    return self;
}

- (double)getCaloriesForMeal:(MHMeal *)meal {
    double calories = 0;
    
    for (MHConsumedFood *consumedFood in meal.foods) {
        calories += [consumedFood totalCalories];
    }
    
    return calories;
}

- (double)getTotalCalories {
    [self updateTotalNutrition];
    return self.calories;
}

- (double)getTotalFat {
    [self updateTotalNutrition];
    return self.fat;
}

- (double)getTotalCarbs {
    [self updateTotalNutrition];
    return self.carbs;
}

- (double)getTotalProtein {
    [self updateTotalNutrition];
    return self.protein;
}

- (void)updateTotalNutrition {
    self.calories = 0;
    self.fat = 0;
    self.carbs = 0;
    self.protein = 0;
    
    for (MHMeal *meal in self.day.meals) {
        for (MHConsumedFood *consumedFood in meal.foods) {
            self.calories += [consumedFood totalCalories];
            self.fat += [consumedFood totalFat];
            self.carbs += [consumedFood totalCarbs];
            self.protein += [consumedFood totalProtein];
        }
    }
}

- (void)addFood:(MHConsumedFood *)food inMeal:(MHMeal *)meal {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [meal.foods addObject:food];
    }];
}

- (void)updateFood:(MHConsumedFood *)food toMeal:(MHMeal *)meal withServing:(MHServing *)serving withNumberOfServings:(double)numberOfServings {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        food.serving = serving;
        food.numberOfServings = numberOfServings;
        
        if (![food.meal[0] isEqualToObject:meal]) {
            MHMeal *oldMeal = food.meal[0];
            
            [oldMeal.foods removeObjectAtIndex:[oldMeal.foods indexOfObject:food]];
            [meal.foods addObject:food];
        }
    }];
}

- (void)removeFood:(MHConsumedFood *)food {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObject:food];
    }];
}

- (void)quickAddFoodWithName:(NSString *)name
                    calories:(double)calories
                      inMeal:(MHMeal *)meal {
    
    MHFood *food = [[MHFood alloc] init];
    food.calories = [NSNumber numberWithDouble:calories];
    food.name = name;
    
    MHConsumedFood *consumedFood = [[MHConsumedFood alloc] init];
    consumedFood.food = food;
    
    [self addFood:consumedFood inMeal:meal];
}

- (void)searchFoodsWithExpression:(NSString *)expression {
    NSString *route = @"/rest/server.api";
    NSURL *baseURL = [NSURL URLWithString:@"http://platform.fatsecret.com"];
    NSString *method = @"GET";

    NSDictionary<NSString *, id> *parameters = @{
            @"method": @"foods.search",
            @"format": @"json",
            @"search_expression": expression
    };
    
    NSLog(@"Searching with expression: %@", expression);
    
    [APIManager oauthTaskWithRoute:route
                          atBaseURL:baseURL
                        usingMethod:method
                     withParameters:parameters
                    withConsumerKey:self.apiConsumerKey
                 withConsumerSecret:self.apiConsumerSecret
                   withAccessSecret:@""
                         completion:^(NSDictionary<NSString *,id> *json) {
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 id result = json[@"foods"][@"food"];
                                 
                                 if (!result) {
                                     self.searchResults = @[];
                                     [self.searchDelegate mealManagerDidFinishSearch:self];
                                     return;
                                 }
                                 
                                 NSArray *foodsJSON;
                                 if ([result isKindOfClass:[NSArray class]]) {
                                     foodsJSON = result;
                                 } else {
                                     foodsJSON = @[result];
                                 }
                                 
                                 NSMutableArray<MHFood *> *results = [NSMutableArray new];
                                 
                                 for (NSDictionary *foodData in foodsJSON) {
                                     MHFood *food = [[MHFood alloc] init];
                                     
                                     NSString *desc = foodData[@"food_description"];
                                     NSArray<NSString *> *nutritionInfo = [[desc componentsSeparatedByString:@" - "][1] componentsSeparatedByString:@" | "];
                                     
                                     NSString *caloriesInfo = [nutritionInfo[0] componentsSeparatedByString:@": "][1];
                                     NSString *fatInfo = [nutritionInfo[1] componentsSeparatedByString:@": "][1];
                                     NSString *carbsInfo = [nutritionInfo[2] componentsSeparatedByString:@": "][1];
                                     NSString *proteinInfo = [nutritionInfo[3] componentsSeparatedByString:@": "][1];

                                     food.calories = [NSNumber numberWithDouble:[[caloriesInfo substringToIndex:caloriesInfo.length - 4] doubleValue]];
                                     food.fat = [NSNumber numberWithDouble:[[fatInfo substringToIndex:fatInfo.length - 1] doubleValue]];
                                     food.carbs = [NSNumber numberWithDouble:[[carbsInfo substringToIndex:carbsInfo.length - 1] doubleValue]];
                                     food.protein = [NSNumber numberWithDouble:[[proteinInfo substringToIndex:proteinInfo.length - 1] doubleValue]];
                                     food.serving = [[desc componentsSeparatedByString:@" - "][0] componentsSeparatedByString:@" "][1];
                                     
                                     food.name = foodData[@"food_name"];
                                     
                                     if ([foodData[@"food_type"] isEqualToString:@"Brand"]) {
                                         food.brand = foodData[@"brand_name"];
                                     }
                                     
                                     food.foodId = [(NSNumber *)foodData[@"food_id"] intValue];
                                     
                                     [results addObject:food];
                                 }
                                 
                                 self.searchResults = results;
                                 
                                 [self.searchDelegate mealManagerDidFinishSearch:self];
                             });
                         }];


}

- (void)getDetailsForFood:(MHFood *)food {
    NSString *route = @"/rest/server.api";
    NSURL *baseURL = [NSURL URLWithString:@"http://platform.fatsecret.com"];
    NSString *method = @"GET";
    
    NSDictionary<NSString *, id> *parameters = @{
                                                 @"method": @"food.get",
                                                 @"format": @"json",
                                                 @"food_id": [NSString stringWithFormat:@"%d", food.foodId]
                                                 };
    
    [APIManager oauthTaskWithRoute:route
                          atBaseURL:baseURL
                        usingMethod:method
                     withParameters:parameters
                    withConsumerKey:self.apiConsumerKey
                 withConsumerSecret:self.apiConsumerSecret
                   withAccessSecret:@""
                         completion:^(NSDictionary<NSString *,id> *json) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 NSArray *servingJSON;
                                 id result = json[@"food"][@"servings"][@"serving"];
                                 if ([result isKindOfClass:[NSArray class]]) {
                                     servingJSON = result;
                                 } else {
                                     servingJSON = @[result];
                                 }
                                 
                                 bool defaultSet = false;
                                 for (NSDictionary *foodData in servingJSON) {
                                     NSNumber *calories = [self getDecimalStringAsNumber:foodData[@"calories"]];
                                     RLMRealm *realm = [RLMRealm defaultRealm];
                                     
                                     [realm beginWriteTransaction];
                                     MHServing *serving = [[MHServing alloc] init];
                                     
                                     serving.desc = foodData[@"serving_description"];
                                     if (foodData[@"metric_serving_amount"]) {
                                         serving.amount = [self getDecimalStringAsNumber:foodData[@"metric_serving_amount"]];
                                         NSString *unit = foodData[@"metric_serving_unit"];
                                         if ([unit isEqualToString:@"g"]) {
                                             serving.unit = @0;
                                         } else if ([unit isEqualToString:@"ml"]) {
                                             serving.unit = @1;
                                         } else if ([unit isEqualToString:@"oz"]) {
                                             serving.unit = @2;
                                         } else {
                                             [NSException raise:@"UnrecognizedValue" format:@"Serving Unit Not Recognized"];
                                         }
                                     }
                                     
                                     [realm addObject:serving];
                                     [food.servings addObject:serving];
                                     
                                     if (!defaultSet || [calories isEqualToNumber:food.calories]) {
                                         food.calcium = [self getDecimalStringAsNumber:foodData[@"calories"]];
                                         food.carbs = [self getDecimalStringAsNumber:foodData[@"carbohydrate"]];
                                         food.cholesterol = [self getDecimalStringAsNumber:foodData[@"cholesterol"]];
                                         food.fiber = [self getDecimalStringAsNumber:foodData[@"fiber"]];
                                         food.iron = [self getDecimalStringAsNumber:foodData[@"iron"]];
                                         food.transFat = [self getDecimalStringAsNumber:foodData[@"trans_fat"]];
                                         food.monounsaturatedFat = [self getDecimalStringAsNumber:foodData[@"monounsaturated_fat"]];
                                         food.polyunsaturatedFat = [self getDecimalStringAsNumber:foodData[@"polyunsaturated_fat"]];
                                         food.saturatedFat = [self getDecimalStringAsNumber:foodData[@"saturated_fat"]];
                                         food.potassium = [self getDecimalStringAsNumber:foodData[@"potassium"]];
                                         food.sodium = [self getDecimalStringAsNumber:foodData[@"sodium"]];
                                         food.sugar = [self getDecimalStringAsNumber:foodData[@"sugar"]];
                                         food.vitaminA = [self getDecimalStringAsNumber:foodData[@"vitamin_a"]];
                                         food.vitaminC = [self getDecimalStringAsNumber:foodData[@"vitamin_c"]];
                                         
                                         food.defaultServing = serving;
                                         defaultSet = true;
                                     }
                                     [[RLMRealm defaultRealm] commitWriteTransaction];
                                 }
                                 
                                 [self.searchDelegate mealManager:self didFinishGettingDetailsForFood:food];
                             });
                         }];

}

- (NSNumber *)getDecimalStringAsNumber:(NSString *)str {
    return [NSNumber numberWithDouble:[str doubleValue]];
}

- (void)didCancelSearch {
    self.searchResults = [[NSArray<MHFood *> alloc] init];
}

- (RLMArray<MHMeal *> *)meals {
    return self.day.meals;
}

- (NSString *)titleForMeal:(MHMeal *)meal {
    NSArray *mealNames = @[@"Breakfast", @"Lunch", @"Dinner", @"Snacks"];

    return mealNames[[self.day.meals indexOfObject:meal]];
}

@end
