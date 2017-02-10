//
//  MealManager.h
//  Mission Health
//
//  Created by Connor Krupp on 2/9/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MealManager : NSObject

@property (strong, nonatomic) NSArray<NSMutableArray *> *meals;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
    
- (void)quickAddFoodWithName:(NSString *)name
                    calories:(double)calories
                      inMeal:(NSString *)meal;


@end
