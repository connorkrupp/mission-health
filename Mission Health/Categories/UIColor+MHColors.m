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
    return [UIColor primaryColor];
}

+ (UIColor *)negativeColor {
    return [UIColor colorWithRed:255.0/255 green:107.0/255 blue:107.0/255 alpha:1.0];
}

+ (UIColor *)neutralColor {
    return [UIColor colorWithRed:26.0/255 green:83.0/255 blue:92.0/255 alpha:1.0];
}

+ (UIColor *)primaryColor {
    return [UIColor colorWithRed:78.0/255.0 green:205.0/255.0 blue:196.0/255.0 alpha:1.0];
}

+ (UIColor *)highlightColor {
    return [UIColor colorWithRed:255.0/255.0 green:230.0/255.0 blue:109.0/255.0 alpha:1.0];
}

+ (NSArray<UIColor *> *)flatColors {
    return @[
             [UIColor colorWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1.0],
             [UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1.0],
             [UIColor colorWithRed:155/255.0 green:89/255.0 blue:182/255.0 alpha:1.0],
             [UIColor colorWithRed:52/255.0 green:73/255.0 blue:94/255.0 alpha:1.0],
             [UIColor colorWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1.0],
             [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1.0],
             [UIColor colorWithRed:127/255.0 green:140/255.0 blue:141/255.0 alpha:1.0],
             ];

}

@end
