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
        NSError *error = [[NSError alloc] initWithDomain:NSSQLiteErrorDomain code:0 userInfo:nil];
        NSArray *foods = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        
        
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
    
    NSArray *mealNames = @[@"breakfast", @"lunch", @"dinner", @"snacks"];
    
    NSUInteger mealIndex = [mealNames indexOfObject:meal];
    if (mealIndex == NSNotFound) {
        meal = @"snacks";
        mealIndex = [mealNames indexOfObject:meal];
    }
    
    Food *food = [self createFoodWithName:name calories:calories inMeal:meal inManagedObjectContext:self.managedObjectContext];
    
    NSError *error = nil;
    if ([self.managedObjectContext save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    
    NSMutableArray *mealArray = self.meals[mealIndex];
    
    [mealArray addObject:food];
}

- (Food *)createFoodInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Food *food = [NSEntityDescription insertNewObjectForEntityForName:@"Food"
                                                 inManagedObjectContext:managedObjectContext];
    
    return food;
}

- (Food *)createFoodWithName:(NSString *)name
                    calories:(double)calories
                      inMeal:(NSString *)meal
      inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    Food *food = [self createFoodInManagedObjectContext:managedObjectContext];
    
    food.name = name;
    food.calories = calories;
    food.meal = meal;
    food.date = [NSDate new];
    
    return food;
}

@end
