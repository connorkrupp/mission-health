//
//  FoodDetailViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 4/26/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MealManager;
@class MHFood;

@interface FoodDetailViewController : UIViewController

- (instancetype)initWithMealManager:(MealManager *)mealManager food:(MHFood *)food;

@end
