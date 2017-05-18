//
//  NSDate+JSONFormat.h
//  Mission Health
//
//  Created by Connor Krupp on 5/17/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JSONFormat)

+ (NSDate *)dateFromJSONString:(NSString *)str;

@end
