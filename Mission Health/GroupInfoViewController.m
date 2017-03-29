//
//  GroupInfoViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 3/29/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "GroupInfoViewController.h"

@interface GroupInfoViewController () <UITableViewDataSource>

@property (strong, nonatomic) UITableView *membersTableView;
@property (strong, nonatomic) MHGroup *group;

@end

@implementation GroupInfoViewController

static NSString *memberCellIdentifier = @"Member Cell";

- (instancetype)initWithGroup:(MHGroup *)group {
    if (self = [super init]) {
        self.group = group;
    }
    
    return self;
}

- (void)loadView {
    self.view = [UIView new];
    
    self.membersTableView = [UITableView new];
    self.membersTableView.dataSource = self;
    self.membersTableView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.membersTableView registerClass:[UITableViewCell class] forCellReuseIdentifier: memberCellIdentifier];
    
    [self.view addSubview:self.membersTableView];
    
    [NSLayoutConstraint activateConstraints:@[
                  
          [NSLayoutConstraint constraintWithItem:self.membersTableView
                                       attribute:NSLayoutAttributeLeading
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view attribute:NSLayoutAttributeLeading
                                      multiplier:1.0
                                        constant:0.0],
          [NSLayoutConstraint constraintWithItem:self.membersTableView
                                       attribute:NSLayoutAttributeTrailing
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view attribute:NSLayoutAttributeTrailing
                                      multiplier:1.0
                                        constant:0.0],
          [NSLayoutConstraint constraintWithItem:self.membersTableView
                                       attribute:NSLayoutAttributeBottom
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view attribute:NSLayoutAttributeBottom
                                      multiplier:1.0
                                        constant:0.0],
          [NSLayoutConstraint constraintWithItem:self.membersTableView
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view attribute:NSLayoutAttributeTop
                                      multiplier:1.0
                                        constant:0.0]
          
    ]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.group.members count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.membersTableView dequeueReusableCellWithIdentifier:memberCellIdentifier];
    
    cell.textLabel.text = self.group.members[indexPath.row].name;
    
    return cell;
    
}

@end
