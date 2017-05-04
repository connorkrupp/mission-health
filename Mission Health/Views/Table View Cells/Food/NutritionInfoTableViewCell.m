//
//  NutritionInfoTableViewCell.m
//  Mission Health
//
//  Created by Connor Krupp on 5/4/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "NutritionInfoTableViewCell.h"

@implementation NutritionInfoTableViewCell

- (instancetype)init {
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.detailLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont fontWithName:@"HKGrotesk-Regular" size:16.0];
        self.titleLabel.adjustsFontSizeToFitWidth = true;
        
        self.detailLabel.font = [UIFont fontWithName:@"HKGrotesk-Regular" size:16.0];
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        
        UIStackView *containerStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.detailLabel]];
        containerStackView.axis = UILayoutConstraintAxisHorizontal;
        containerStackView.distribution = UIStackViewDistributionEqualSpacing;
        containerStackView.spacing = 20.0;
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false;
        
        [self addSubview:containerStackView];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  
                                                  [NSLayoutConstraint constraintWithItem:containerStackView
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self attribute:NSLayoutAttributeTop
                                                                              multiplier:1.0
                                                                                constant:12.0],
                                                  [NSLayoutConstraint constraintWithItem:containerStackView
                                                                               attribute:NSLayoutAttributeLeading
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self attribute:NSLayoutAttributeLeading
                                                                              multiplier:1.0
                                                                                constant:20.0],
                                                  [NSLayoutConstraint constraintWithItem:containerStackView
                                                                               attribute:NSLayoutAttributeTrailing
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self attribute:NSLayoutAttributeTrailing
                                                                              multiplier:1.0
                                                                                constant:-20.0],
                                                  [NSLayoutConstraint constraintWithItem:containerStackView
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self attribute:NSLayoutAttributeBottom
                                                                              multiplier:1.0
                                                                                constant:-12.0]
                                                  
                                                  ]];
        
    }
    return self;
}

@end
