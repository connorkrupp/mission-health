//
//  NSDate+JSONFormat.m
//  Mission Health
//
//  Created by Connor Krupp on 5/17/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "NSDate+JSONFormat.h"

@implementation NSDate (JSONFormat)

+ (NSDate *)dateFromJSONString:(NSString *)str {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    return [dateFormat dateFromString:str];
}

@end
