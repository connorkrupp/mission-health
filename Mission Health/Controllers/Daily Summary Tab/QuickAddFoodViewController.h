//
//  QuickAddFoodViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 2/9/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealManager.h"

@interface QuickAddFoodViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithMealManager:(MealManager *)mealManager;

@end
