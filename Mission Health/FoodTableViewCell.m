//
//  FoodTableViewCell.m
//  Mission Health
//
//  Created by Connor Krupp on 4/3/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "FoodTableViewCell.h"

@interface FoodTableViewCell ()


@end

@implementation FoodTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.subtitleLabel = [[UILabel alloc] init];
        self.detailLabel = [[UILabel alloc] init];
        
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.adjustsFontSizeToFitWidth = true;
        
        self.subtitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.subtitleLabel.textColor = [UIColor grayColor];
        
        self.detailLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        
        UIStackView *primaryContentStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.subtitleLabel]];
        primaryContentStackView.axis = UILayoutConstraintAxisVertical;
        primaryContentStackView.spacing = 2;
        
        UIStackView *containerStackView = [[UIStackView alloc] initWithArrangedSubviews:@[primaryContentStackView, self.detailLabel]];
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
                                                constant:6.0],
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
                                                constant:-6.0]
      
          ]];

    }
    return self;
}

@end
