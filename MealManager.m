//
//  MealManager.m
//  Mission Health
//
//  Created by Connor Krupp on 2/9/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

@import CoreData;

#import "MealManager.h"
#import "Food+CoreDataClass.h"

@implementation MealManager

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [super init]) {
        self.managedObjectContext = managedObjectContext;
        self.meals = @[[NSMutableArray new],[NSMutableArray new],[NSMutableArray new],[NSMutableArray new]];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
        NSArray *foods = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        NSArray *mealNames = @[@"breakfast", @"lunch", @"dinner", @"snacks"];
        for (Food *food in foods) {
            [self.meals[[mealNames indexOfObject:food.meal]] addObject:food];
        }
    }
    
    return self;
}

- (void)quickAddFoodWithName:(NSString *)name
                    calories:(double)calories
                      inMeal:(NSString *)meal {
    
    Food *food = [self createFoodInManagedObjectContext:self.managedObjectContext];
    
    food.name = name;
    food.calories = calories;
    food.meal = meal;
    
    NSArray *mealNames = @[@"breakfast", @"lunch", @"dinner", @"snacks"];
    
    NSUInteger mealIndex = [mealNames indexOfObject:food.meal];
    if (mealIndex == NSNotFound) {
        mealIndex = 3;
    }
    
    [self.managedObjectContext save:nil];
    
    NSMutableArray *mealArray = self.meals[mealIndex];
    
    [mealArray addObject:food];
}

- (Food *)createFoodInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Food *food = [NSEntityDescription insertNewObjectForEntityForName:@"Food"
                                                 inManagedObjectContext:managedObjectContext];
    
    return food;
}

@end
