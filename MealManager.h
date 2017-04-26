//
//  MealManager.h
//  Mission Health
//
//  Created by Connor Krupp on 2/9/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHFood.h"

@class MealManager;

@protocol MealManagerDelegate <NSObject>

- (void)mealManagerDidFinishSearch:(MealManager *)mealManager;

@end

@interface MealManager : NSObject

@property (strong, nonatomic) NSArray<NSMutableArray<MHFood *> *> *meals;
@property (strong, nonatomic) NSArray<MHFood *> *searchResults;
@property (weak, nonatomic) id<MealManagerDelegate> delegate;

- (void)addFood:(MHFood *)food;

- (void)quickAddFoodWithName:(NSString *)name
                    calories:(double)calories
                      inMeal:(int)meal;

- (void)searchFoodsWithExpression:(NSString *)expression;
- (void)didCancelSearch;

@end
