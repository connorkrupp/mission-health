//
//  NSString+PrettyDates.h
//  Mission Health
//
//  Created by Connor Krupp on 5/3/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PrettyDates)

+ (NSString *)formattedStringFromDate:(NSDate *)date;

@end
