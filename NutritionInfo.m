//
// Created by Connor Krupp on 4/23/17.
// Copyright (c) 2017 Connor Krupp. All rights reserved.
//

#import "NutritionInfo.h"


@implementation NutritionInfo

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"NutritionInfo" owner:self options:nil] objectAtIndex:0];

    return self;
}

@end
