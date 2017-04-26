//
//  FoodSearchViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 4/3/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealManager.h"

@interface FoodSearchViewController : UIViewController

- (instancetype)initWithMealManager:(MealManager *)mealManager;
    
@end
