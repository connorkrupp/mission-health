//
//  MHConsumedFood.m
//  Mission Health
//
//  Created by Connor Krupp on 5/4/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "MHConsumedFood.h"
#import "MHMeal.h"
#import "MHServing.h"
#import "MHFood.h"

@implementation MHConsumedFood

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}


+ (NSDictionary *)linkingObjectsProperties {
    return @{
             @"meal": [RLMPropertyDescriptor descriptorWithClass:MHMeal.class propertyName:@"foods"],
             };
}

- (double)totalCalories {
    double scale = [self.serving.amount doubleValue] / [self.food.defaultServing.amount doubleValue];
    return self.numberOfServings * scale * [self.food.calories doubleValue];
}

- (double)totalFat {
    double scale = [self.serving.amount doubleValue] / [self.food.defaultServing.amount doubleValue];
    return self.numberOfServings * scale * [self.food.fat doubleValue];
}

- (double)totalProtein {
    double scale = [self.serving.amount doubleValue] / [self.food.defaultServing.amount doubleValue];
    return self.numberOfServings * scale * [self.food.protein doubleValue];
}

- (double)totalCarbs {
    double scale = [self.serving.amount doubleValue] / [self.food.defaultServing.amount doubleValue];
    return self.numberOfServings * scale * [self.food.carbs doubleValue];
}


@end
