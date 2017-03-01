//
//  MealManager.m
//  Mission Health
//
//  Created by Connor Krupp on 2/9/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

@import Realm;

#import "MealManager.h"
#import "MHFood.h"

@implementation MealManager

- (instancetype)init {
    if (self = [super init]) {
        self.meals = @[[NSMutableArray new],[NSMutableArray new],[NSMutableArray new],[NSMutableArray new]];
        
        RLMResults<MHFood *> *foods = [MHFood allObjects];
        
        for (MHFood *food in foods) {
            [self.meals[food.meal] addObject:food];
        }
    }
    
    return self;
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
    
    NSMutableArray *mealArray = self.meals[food.meal];
    
    [mealArray addObject:food];
}

@end
