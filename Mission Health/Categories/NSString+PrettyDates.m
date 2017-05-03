//
//  NSString+PrettyDates.m
//  Mission Health
//
//  Created by Connor Krupp on 5/3/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "NSString+PrettyDates.h"

@implementation NSString (PrettyDates)

+ (NSString *)formattedStringFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [calendar startOfDayForDate:[NSDate new]];
    NSDate *givenDay = [calendar startOfDayForDate:date];
    
    if ([givenDay isEqualToDate:today]) {
        return @"Today";
    }
    
    NSDate *prevGivenDay = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:givenDay options:NSCalendarMatchFirst];
    if ([prevGivenDay isEqualToDate:today]) {
        return @"Tomorrow";
    }
    
    NSDate *nextGivenDay = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:givenDay options:NSCalendarMatchFirst];
    if ([nextGivenDay isEqualToDate:today]) {
        return @"Yesterday";
    }
    
    return [NSDateFormatter localizedStringFromDate:date
                                          dateStyle:NSDateFormatterMediumStyle
                                          timeStyle:NSDateFormatterNoStyle];
}

@end
