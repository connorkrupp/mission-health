//
//  MHGroup.m
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "MHGroup.h"

@implementation MHGroup

+ (NSString *)primaryKey {
    return @"groupId";
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{
             @"lastUpdatedMetadata": [NSDate dateWithTimeIntervalSince1970:0],
             @"lastUpdatedMessages": [NSDate dateWithTimeIntervalSince1970:0]
             };
}

@end
