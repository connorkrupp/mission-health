//
//  MissionsCollectionViewCell.m
//  HealthFit
//
//  Created by Connor Krupp on 2/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "MissionsCollectionViewCell.h"

@implementation MissionsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addViews];
    }
    
    return self;
}

- (void)addViews {
    self.missionsLabel = [[UILabel alloc] init];
    self.missionsLabel.textAlignment = NSTextAlignmentCenter;
    
    self.missionsLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.contentView addSubview:self.missionsLabel];
    
    [NSLayoutConstraint activateConstraints:@[
                  
          [NSLayoutConstraint constraintWithItem:self.missionsLabel
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.contentView attribute:NSLayoutAttributeTop
                                      multiplier:1.0
                                        constant:0.0],
          [NSLayoutConstraint constraintWithItem:self.missionsLabel
                                       attribute:NSLayoutAttributeLeading
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.contentView attribute:NSLayoutAttributeLeading
                                      multiplier:1.0
                                        constant:0.0],
          [NSLayoutConstraint constraintWithItem:self.missionsLabel
                                       attribute:NSLayoutAttributeTrailing
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.contentView attribute:NSLayoutAttributeTrailing
                                      multiplier:1.0
                                        constant:0.0],
          [NSLayoutConstraint constraintWithItem:self.missionsLabel
                                       attribute:NSLayoutAttributeBottom
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.contentView attribute:NSLayoutAttributeBottom
                                      multiplier:1.0
                                        constant:0.0]
          
    ]];
}

@end
