//
//  UserManager.h
//  Mission Health
//
//  Created by Connor Krupp on 2/9/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHUser+CoreDataProperties.h"
#import "MealManager.h"

@interface UserManager : NSObject

@property (strong, nonatomic) MHUser *user;
@property (strong, nonatomic) MealManager *mealManager;

@end
