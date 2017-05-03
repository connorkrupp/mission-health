//
//  DailySummaryViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 2/7/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MealManager;
@class MHFood;
@class DailySummaryViewController;

@protocol DailySummaryViewControllerDelegate <NSObject>

- (void)dailySummaryViewController:(DailySummaryViewController *)dailySummaryViewController didTapAddFoodWithMealManager:(MealManager *)mealManager;
- (void)dailySummaryViewController:(DailySummaryViewController *)dailySummaryViewController didNavigateToDate:(NSDate *)toDate fromDate:(NSDate *)fromDate;
- (void)dailySummaryViewController:(DailySummaryViewController *)dailySummaryViewController didSelectFood:(MHFood *)food withMealManager:(MealManager *)mealManager;

@end

@interface DailySummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id<DailySummaryViewControllerDelegate> coordinator;

- (instancetype)initWithMealManager:(MealManager *)mealManager;

@end
