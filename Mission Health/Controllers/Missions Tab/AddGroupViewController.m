//
//  AddGroupViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "AddGroupViewController.h"
#import "TextFieldTableViewCell.h"
#import "GroupListManager.h"

@interface AddGroupViewController ()

@property (strong, nonatomic) GroupListManager *groupListManager;
@property (strong, nonatomic) TextFieldTableViewCell *addGroupTableViewCell;
@property (strong, nonatomic) TextFieldTableViewCell *createGroupTableViewCell;

@end

@implementation AddGroupViewController

- (instancetype)initWithGroupListManager:(GroupListManager *)groupListManager {
    self.groupListManager = groupListManager;
    
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)loadView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.view = tableView;
    self.tableView = tableView;
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.navigationItem.title = @"Add Group";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.addGroupTableViewCell = [[TextFieldTableViewCell alloc] init];
    self.addGroupTableViewCell.titleLabel.text = @"Group ID";
    self.addGroupTableViewCell.textField.placeholder = @"Group ID";
    self.addGroupTableViewCell.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.createGroupTableViewCell = [[TextFieldTableViewCell alloc] init];
    self.createGroupTableViewCell.titleLabel.text = @"Group Name";
    self.createGroupTableViewCell.textField.placeholder = @"Group Name";
    self.createGroupTableViewCell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
}

- (void)cancel {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)saveItem {
    if ([self.addGroupTableViewCell.textField.text length] > 0) {
        NSString *groupId = self.addGroupTableViewCell.textField.text;
        [self.groupListManager joinGroup:groupId];
        [self dismissViewControllerAnimated:true completion:nil];
    } else if ([self.createGroupTableViewCell.textField.text length] > 0) {
        [self.groupListManager createGroup:self.createGroupTableViewCell.textField.text];
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Add Group";
    } else if (section == 1) {
        return @"Create Group";
    }
    
    return @"ERR";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.addGroupTableViewCell;
    } else if (indexPath.section == 1) {
        return self.createGroupTableViewCell;
    }
    
    return nil;
}
@end
