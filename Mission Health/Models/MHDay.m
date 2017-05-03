//
//  MHDay.m
//  Mission Health
//
//  Created by Connor Krupp on 5/2/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "MHDay.h"

@implementation MHDay

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    MHMeal *breakfast = [[MHMeal alloc] init];
    MHMeal *lunch = [[MHMeal alloc] init];
    MHMeal *dinner = [[MHMeal alloc] init];
    MHMeal *snack = [[MHMeal alloc] init];
    NSDate *todayDate = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];

    return @{@"date": todayDate, @"meals": @[breakfast, lunch, dinner, snack]};
}

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super init]) {
        self.date = date;
    }
    return self;
}

@end
