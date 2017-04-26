//
//  WeightInfo.m
//  Mission Health
//
//  Created by Connor Krupp on 4/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "WeightInfo.h"

@implementation WeightInfo

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"WeightInfo" owner:self options:nil] objectAtIndex:0];
    
    return self;
}

@end
