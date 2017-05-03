//
//  FoodSearchViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 4/3/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MealManager;
@class MHFood;
@class FoodSearchViewController;

@protocol FoodSearchViewControllerDelegate <NSObject>

- (void)foodSearchViewControllerDidCancel:(FoodSearchViewController *)foodSearchViewController;
- (void)foodSearchViewController:(FoodSearchViewController *)foodSearchViewController didTapQuickAddWithMealManager:(MealManager *)mealManager;
- (void)foodSearchViewController:(FoodSearchViewController *)foodSearchViewController didGetDetailsForFood:(MHFood *)food withMealManager:(MealManager *)mealManager;

@end

@interface FoodSearchViewController : UIViewController

@property (weak, nonatomic) id<FoodSearchViewControllerDelegate> coordinator;

- (instancetype)initWithMealManager:(MealManager *)mealManager;
    
@end
