//
//  DailySummaryViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 2/7/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealManager.h"

@interface DailySummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithMealManager:(MealManager *)mealManager;

@end
