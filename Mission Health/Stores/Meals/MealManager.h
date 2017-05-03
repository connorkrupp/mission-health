//
//  MealManager.h
//  Mission Health
//
//  Created by Connor Krupp on 2/9/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHFood.h"
#import "MHMeal.h"

@class MealManager;

@protocol MealManagerSearchDelegate <NSObject>

- (void)mealManagerDidFinishSearch:(MealManager *)mealManager;
- (void)mealManager:(MealManager *)mealManager didFinishGettingDetailsForFood:(MHFood *)food;

@end

@interface MealManager : NSObject

@property (strong, nonatomic, readonly) RLMArray<MHMeal *> *meals;
@property (strong, nonatomic) NSArray<MHFood *> *searchResults;
@property (weak, nonatomic) id<MealManagerSearchDelegate> searchDelegate;
@property (strong, nonatomic) NSDate *date;

- (instancetype)initWithDate:(NSDate *)date;

- (double)getCaloriesForMeal:(MHMeal *)meal;
- (double)getTotalCalories;
- (double)getTotalFat;
- (double)getTotalCarbs;
- (double)getTotalProtein;


- (void)addFood:(MHFood *)food inMeal:(MHMeal *)meal;
- (void)removeFood:(MHFood *)food;

- (void)quickAddFoodWithName:(NSString *)name
                    calories:(double)calories
                      inMeal:(MHMeal *)meal;

- (void)searchFoodsWithExpression:(NSString *)expression;
- (void)didCancelSearch;

- (void)getDetailsForFood:(MHFood *)food;

@end
