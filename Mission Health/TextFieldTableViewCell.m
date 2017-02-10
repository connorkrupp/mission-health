//
//  TextFieldTableViewCell.m
//  Mission Health
//
//  Created by Connor Krupp on 2/9/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@implementation TextFieldTableViewCell

- (instancetype)init {
    if (self = [super init]) {
        self.textField = [[UITextField alloc] init];
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false;
        
        [self.contentView addSubview:self.textField];
        
        [NSLayoutConstraint activateConstraints:@[
                      
              [NSLayoutConstraint constraintWithItem:self.textField
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self.contentView attribute:NSLayoutAttributeTop
                                          multiplier:1.0
                                            constant:0.0],
              [NSLayoutConstraint constraintWithItem:self.textField
                                           attribute:NSLayoutAttributeLeading
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self.contentView attribute:NSLayoutAttributeLeading
                                          multiplier:1.0
                                            constant:20.0],
              [NSLayoutConstraint constraintWithItem:self.textField
                                           attribute:NSLayoutAttributeTrailing
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self.contentView attribute:NSLayoutAttributeTrailing
                                          multiplier:1.0
                                            constant:20.0],
              [NSLayoutConstraint constraintWithItem:self.textField
                                           attribute:NSLayoutAttributeBottom
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self.contentView attribute:NSLayoutAttributeBottom
                                          multiplier:1.0
                                            constant:0.0]
              
        ]];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
