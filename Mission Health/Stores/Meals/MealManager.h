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
- (void)mealManager:(MealManager *)mealManager didGettingDetailsForFood:(MHFood *)food;

@end

@interface MealManager : NSObject

@property (strong, nonatomic) NSArray<NSMutableArray<MHFood *> *> *meals;
@property (strong, nonatomic) NSArray<MHFood *> *searchResults;
@property (weak, nonatomic) id<MealManagerDelegate> delegate;

- (double)getCaloriesForMeal:(int)meal;
- (double)getTotalCalories;
- (double)getTotalFat;
- (double)getTotalCarbs;
- (double)getTotalProtein;


- (void)addFood:(MHFood *)food;

- (void)quickAddFoodWithName:(NSString *)name
                    calories:(double)calories
                      inMeal:(int)meal;

- (void)searchFoodsWithExpression:(NSString *)expression;
- (void)didCancelSearch;

- (void)getDetailsForFood:(MHFood *)food;

@end
