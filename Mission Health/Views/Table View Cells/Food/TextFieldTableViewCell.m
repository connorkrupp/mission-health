//
//  TextFieldTableViewCell.m
//  Mission Health
//
//  Created by Connor Krupp on 5/3/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "TextFieldTableViewCell.h"
#import "UIColor+MHColors.h"

@implementation TextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.titleLabel = [[UILabel alloc] init];
        self.textField = [[UITextField alloc] init];
        
        self.titleLabel.font = [UIFont fontWithName:@"HKGrotesk-SemiBold" size:16.0];
        
        self.textField.font = [UIFont fontWithName:@"HKGrotesk-SemiBold" size:16.0];
        self.textField.textAlignment = NSTextAlignmentRight;
        [self.textField setTextColor:[UIColor primaryColor]];
        
        UIStackView *labelsStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.textField]];
        labelsStackView.axis = UILayoutConstraintAxisHorizontal;
        labelsStackView.distribution = UIStackViewDistributionFillEqually;
        
        UIStackView *containerStackView = [[UIStackView alloc] initWithArrangedSubviews:@[labelsStackView, self.textField]];
        containerStackView.axis = UILayoutConstraintAxisVertical;
        containerStackView.spacing = 20.0;
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false;
        
        [self addSubview:containerStackView];
        
        [NSLayoutConstraint activateConstraints:@[
                                                  [NSLayoutConstraint constraintWithItem:containerStackView
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self attribute:NSLayoutAttributeTop
                                                                              multiplier:1.0
                                                                                constant:20.0],
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
                                                                                constant:-20.0]
                                                  
                                                  ]];
        
    }
    return self;
}



@end
