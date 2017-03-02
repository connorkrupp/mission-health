//
//  GroupViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "GroupViewController.h"

@interface GroupViewController ()

@property (nonatomic, strong) MHGroup *group;

@end

@implementation GroupViewController

- (instancetype)initWithGroup:(MHGroup *)group {
    if (self = [super init]) {
        self.group = group;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    UILabel *namelabel = [[UILabel alloc] init];
    namelabel.textAlignment = NSTextAlignmentCenter;
    UILabel *groupIdlabel = [[UILabel alloc] init];
    groupIdlabel.textAlignment = NSTextAlignmentCenter;
    
    self.title = self.group.name;
    namelabel.text = self.group.name;
    groupIdlabel.text = [NSString stringWithFormat:@"Group ID: %d", self.group.groupId];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[namelabel, groupIdlabel]];
    stackView.axis = UILayoutConstraintAxisVertical;
    
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stackView];
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:@[
                  
          [NSLayoutConstraint constraintWithItem:stackView
                                       attribute:NSLayoutAttributeCenterY
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view attribute:NSLayoutAttributeCenterY
                                      multiplier:1.0
                                        constant:0.0],
          [NSLayoutConstraint constraintWithItem:stackView
                                       attribute:NSLayoutAttributeLeading
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view attribute:NSLayoutAttributeLeading
                                      multiplier:1.0
                                        constant:20.0],
          [NSLayoutConstraint constraintWithItem:stackView
                                       attribute:NSLayoutAttributeTrailing
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view attribute:NSLayoutAttributeTrailing
                                      multiplier:1.0
                                        constant:20.0]
          
    ]];
}

@end
