//
//  MHAccount.m
//  Mission Health
//
//  Created by Connor Krupp on 5/11/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "MHAccount.h"

@implementation MHAccount

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

+ (NSString *)primaryKey {
    return @"userId";
}

@end
