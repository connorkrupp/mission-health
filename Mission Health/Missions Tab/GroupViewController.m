//
//  GroupViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "GroupViewController.h"

#import "GroupInfoViewController.h"

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
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(loadGroupInfo)];
    self.navigationItem.rightBarButtonItem = infoButton;
    
    UILabel *namelabel = [[UILabel alloc] init];
    namelabel.textAlignment = NSTextAlignmentCenter;
    UILabel *groupIdlabel = [[UILabel alloc] init];
    groupIdlabel.textAlignment = NSTextAlignmentCenter;
    UILabel *groupMemberslabel = [[UILabel alloc] init];
    groupMemberslabel.textAlignment = NSTextAlignmentCenter;
    
    self.title = self.group.name;
    namelabel.text = self.group.name;
    groupMemberslabel.text = [NSString stringWithFormat:@"%lu Members", (unsigned long)self.group.members.count];
    groupIdlabel.text = [NSString stringWithFormat:@"Group ID: %d", self.group.groupId];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[namelabel, groupIdlabel, groupMemberslabel]];
    stackView.axis = UILayoutConstraintAxisVertical;
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

- (void)loadGroupInfo {
    GroupInfoViewController *groupInfoViewController = [[GroupInfoViewController alloc] initWithGroup:self.group];
    
    [self.navigationController pushViewController:groupInfoViewController animated:true];
}

@end
