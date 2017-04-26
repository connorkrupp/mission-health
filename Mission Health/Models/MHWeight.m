//
//  MHWeight.m
//  Mission Health
//
//  Created by Connor Krupp on 4/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "MHWeight.h"

@implementation MHWeight

- (instancetype)initWithWeight:(double)weight date:(NSDate *)date {
    self = [super init];
    if (self) {
        self.weight = weight;
        self.date = date;
    }
    return self;
}

@end
