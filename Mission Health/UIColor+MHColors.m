//
//  UIColor+MHColors.m
//  Mission Health
//
//  Created by Connor Krupp on 4/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "UIColor+MHColors.h"

@implementation UIColor (MHColors)

+ (UIColor *)positiveColor {
    return [UIColor colorWithRed:115.0/255 green:193.0/255 blue:179.0/255 alpha:1.0];
}

+ (UIColor *)negativeColor {
    return [UIColor colorWithRed:240.0/255 green:96.0/255 blue:96.0/255 alpha:1.0];
}

+ (UIColor *)neutralColor {
    return [UIColor colorWithRed:42.0/255 green:124.0/255 blue:158.0/255 alpha:1.0];
}

@end
