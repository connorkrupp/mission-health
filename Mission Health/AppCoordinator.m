//
//  AppCoordinator.m
//  Mission Health
//
//  Created by Connor Krupp on 5/3/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "AppCoordinator.h"
#import "MealManager.h"

#import "MissionsCollectionViewController.h"

#import "WeightSummaryViewController.h"

#import "DailySummaryViewController.h"
#import "FoodDetailViewController.h"
#import "FoodSearchViewController.h"
#import "QuickAddFoodViewController.h"

#import "LoginViewController.h"
#import "APIManager.h"
#import "GroupListManager.h"

@interface AppCoordinator () <DailySummaryViewControllerDelegate, FoodSearchViewControllerDelegate>

@property (strong, nonatomic) APIManager *apiManager;

@property (strong, nonatomic) UINavigationController *dailySummaryNavigationController;

@end

@implementation AppCoordinator

- (instancetype)initWithWindow:(UIWindow *)window {
    if (self = [super init]) {
        
        self.apiManager = [[APIManager alloc] init];
        MealManager *mealManager = [[MealManager alloc] init];
        
        MissionsCollectionViewController *groupViewController = [[MissionsCollectionViewController alloc] initWithGroupListManager:self.apiManager.groupListManager];
        UINavigationController *groupNavigationController = [[UINavigationController alloc] initWithRootViewController:groupViewController];
        groupNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Missions" image:[UIImage imageNamed:@"cup"] tag:1];
        
        DailySummaryViewController *dailySummaryViewController = [[DailySummaryViewController alloc] initWithMealManager:mealManager];
        dailySummaryViewController.coordinator = self;
        self.dailySummaryNavigationController = [[UINavigationController alloc] initWithRootViewController:dailySummaryViewController];
        self.dailySummaryNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Summary" image:[UIImage imageNamed:@"log"] tag:2];
        
        WeightSummaryViewController *progressViewController = [[WeightSummaryViewController alloc] init];
        UINavigationController *progressNavigationController = [[UINavigationController alloc] initWithRootViewController:progressViewController];
        progressNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Progress" image:[UIImage imageNamed:@"progress"] tag:3];
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithAuthManager:self.apiManager.authManager];
        UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        profileNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:[UIImage imageNamed:@"profile"] tag:4];
        
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = @[groupNavigationController, self.dailySummaryNavigationController, progressNavigationController, profileNavigationController];
        
        window.rootViewController = tabBarController;
    }
    
    return self;
}

#pragma mark - DailySummaryViewControllerDelegate

- (void)dailySummaryViewController:(DailySummaryViewController *)dailySummaryViewController didTapAddFoodWithMealManager:(MealManager *)mealManager {
    FoodSearchViewController *foodSearchViewController = [[FoodSearchViewController alloc] initWithMealManager:mealManager];
    UINavigationController *addFoodNavigationController = [[UINavigationController alloc] initWithRootViewController:foodSearchViewController];

    foodSearchViewController.coordinator = self;

    [self.dailySummaryNavigationController presentViewController:addFoodNavigationController animated:true completion:nil];
}

- (void)dailySummaryViewController:(DailySummaryViewController *)dailySummaryViewController didNavigateToDate:(NSDate *)toDate fromDate:(NSDate *)fromDate {
    MealManager *newMealManager = [[MealManager alloc] initWithDate:toDate];
    DailySummaryViewController *newDailySummaryViewController = [[DailySummaryViewController alloc] initWithMealManager:newMealManager];
    newDailySummaryViewController.coordinator = self;

    
    if ([fromDate compare:toDate] == NSOrderedAscending) {
        dailySummaryViewController.navigationItem.hidesBackButton = true;
        newDailySummaryViewController.navigationItem.hidesBackButton = true;
        [self.dailySummaryNavigationController setViewControllers:@[newDailySummaryViewController] animated:true];
    } else {
        dailySummaryViewController.navigationItem.hidesBackButton = true;
        newDailySummaryViewController.navigationItem.hidesBackButton = true;
        [self.dailySummaryNavigationController setViewControllers:@[newDailySummaryViewController, dailySummaryViewController]];
        [self.dailySummaryNavigationController popViewControllerAnimated:true];
    }
}

- (void)dailySummaryViewController:(DailySummaryViewController *)dailySummaryViewController didSelectFood:(MHConsumedFood *)food withMealManager:(MealManager *)mealManager {
    FoodDetailViewController *foodDetailViewController = [[FoodDetailViewController alloc] initWithMealManager:mealManager consumedFood:food];
    
    [self.dailySummaryNavigationController pushViewController:foodDetailViewController animated:true];
}

#pragma mark - FoodSearchViewControllerDelegate

- (void)foodSearchViewControllerDidCancel:(FoodSearchViewController *)foodSearchViewController {
    [foodSearchViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)foodSearchViewController:(FoodSearchViewController *)foodSearchViewController didTapQuickAddWithMealManager:(MealManager *)mealManager {
    QuickAddFoodViewController *quickAddFoodViewController = [[QuickAddFoodViewController alloc] initWithMealManager:mealManager];
    
    [self.dailySummaryNavigationController pushViewController:quickAddFoodViewController animated:true];
}

- (void)foodSearchViewController:(FoodSearchViewController *)foodSearchViewController didGetDetailsForFood:(MHFood *)food withMealManager:(MealManager *)mealManager {
    FoodDetailViewController *foodDetailViewController = [[FoodDetailViewController alloc] initWithMealManager:mealManager food:food];
    
    [foodSearchViewController.navigationController pushViewController:foodDetailViewController animated:true];
}

@end
