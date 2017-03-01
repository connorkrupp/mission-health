//
//  MealManager.h
//  Mission Health
//
//  Created by Connor Krupp on 2/9/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHFood.h"

@interface MealManager : NSObject

@property (strong, nonatomic) NSArray<NSMutableArray<MHFood *> *> *meals;

- (void)quickAddFoodWithName:(NSString *)name
                    calories:(double)calories
                      inMeal:(int)meal;


@end
