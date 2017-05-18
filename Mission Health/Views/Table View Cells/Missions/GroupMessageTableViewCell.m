//
//  GroupMessageTableViewCell.m
//  Mission Health
//
//  Created by Connor Krupp on 5/16/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "GroupMessageTableViewCell.h"

@implementation GroupMessageTableViewCell

- (instancetype)init {
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.senderLabel = [[UILabel alloc] init];

        self.senderLabel.font = [UIFont fontWithName:@"HKGrotesk-SemiBold" size:20.0];
        self.senderLabel.numberOfLines = 0;
        self.senderLabel.adjustsFontSizeToFitWidth = true;

        self.timestampLabel = [[UILabel alloc] init];
        self.timestampLabel.font = [UIFont fontWithName:@"HKGrotesk-SemiBold" size:16.0];
        self.timestampLabel.textColor = [UIColor grayColor];

        self.bodyLabel = [[UILabel alloc] init];
        self.bodyLabel.font = [UIFont fontWithName:@"HKGrotesk" size:20.0];
        
        UIStackView *headerContentStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.senderLabel, self.timestampLabel]];
        headerContentStackView.axis = UILayoutConstraintAxisVertical;
        headerContentStackView.spacing = 2;
        
        UIStackView *containerStackView = [[UIStackView alloc] initWithArrangedSubviews:@[headerContentStackView, self.bodyLabel]];
        containerStackView.axis = UILayoutConstraintAxisVertical;
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
