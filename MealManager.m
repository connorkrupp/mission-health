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
#import "MHFood.h"

@interface MealManager ()

@property (strong, nonatomic) NSString *apiConsumerKey;
@property (strong, nonatomic) NSString *apiConsumerSecret;

@end

@implementation MealManager

- (instancetype)init {
    if (self = [super init]) {
        MHFood *food = [[MHFood alloc] init];
        food.calories = 100;
        food.name = @"Shell";
        food.brand = @"The Shellfish Company";
        food.date = [NSDate new];
        food.meal = 0;
        
        self.searchResults = @[food];
        self.meals = @[[NSMutableArray new],[NSMutableArray new],[NSMutableArray new],[NSMutableArray new]];
        
        RLMResults<MHFood *> *foods = [MHFood allObjects];
        
        for (MHFood *food in foods) {
            [self.meals[food.meal] addObject:food];
        }
        
        NSString *configurationPath = [[NSBundle mainBundle] pathForResource:@"configuration" ofType:@"plist"];
        NSDictionary *configuration = [NSDictionary dictionaryWithContentsOfFile:configurationPath];
        self.apiConsumerKey = configuration[@"fatsecret-consumer-key"];
        self.apiConsumerSecret = configuration[@"fatsecret-consumer-secret"];
    }
    
    return self;
}

- (void)addFood:(MHFood *)food {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:food];
    }];
    
    [self.meals[food.meal] addObject:food];
}

- (void)quickAddFoodWithName:(NSString *)name
                    calories:(double)calories
                      inMeal:(int)meal {
    
    MHFood *food = [[MHFood alloc] init];
    food.calories = calories;
    food.name = name;
    food.date = [NSDate new];
    food.meal = meal;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:food];
    }];
    
    [self.meals[meal] addObject:food];
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
    
    [APIManager secureTaskWithRoute:route
                          atBaseURL:baseURL
                        usingMethod:method
                     withParameters:parameters
                    withConsumerKey:self.apiConsumerKey
                 withConsumerSecret:self.apiConsumerSecret
                   withAccessSecret:@""
                         completion:^(NSDictionary<NSString *,id> *json) {
                             NSLog(@"JSON: %@", json);
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 NSMutableArray<MHFood *> *results = [NSMutableArray new];
                                 
                                 for (NSDictionary *foodData in json[@"foods"][@"food"]) {
                                     MHFood *food = [[MHFood alloc] init];
                                     
                                     NSString *desc = foodData[@"food_description"];
                                     NSArray<NSString *> *nutritionInfo = [[desc componentsSeparatedByString:@" - "][1] componentsSeparatedByString:@" | "];
                                     
                                     NSString *caloriesInfo = [nutritionInfo[0] componentsSeparatedByString:@": "][1];
                                     NSString *fatInfo = [nutritionInfo[1] componentsSeparatedByString:@": "][1];
                                     NSString *carbsInfo = [nutritionInfo[2] componentsSeparatedByString:@": "][1];
                                     NSString *proteinInfo = [nutritionInfo[3] componentsSeparatedByString:@": "][1];
                                     
                                     food.calories = [(NSNumber *)[caloriesInfo substringToIndex:caloriesInfo.length - 4] doubleValue];
                                     food.fat = [(NSNumber *)[fatInfo substringToIndex:fatInfo.length - 1] doubleValue];
                                     food.carbs = [(NSNumber *)[carbsInfo substringToIndex:carbsInfo.length - 1] doubleValue];
                                     food.protein = [(NSNumber *)[proteinInfo substringToIndex:proteinInfo.length - 1] doubleValue];
                                     food.serving = [[desc componentsSeparatedByString:@" - "][0] componentsSeparatedByString:@" "][1];
                                     
                                     food.name = foodData[@"food_name"];
                                     
                                     if ([foodData[@"food_type"] isEqualToString:@"Brand"]) {
                                         food.brand = foodData[@"brand_name"];
                                     }
                                     
                                     food.foodId = [(NSNumber *)foodData[@"food_id"] intValue];
                                     
                                     food.meal = 0;
                                     food.date = [NSDate new];
                                     
                                     [results addObject:food];
                                 }
                                 
                                 self.searchResults = results;
                                 
                                 [self.delegate mealManagerDidFinishSearch:self];
                             });
                         }];


}

@end
