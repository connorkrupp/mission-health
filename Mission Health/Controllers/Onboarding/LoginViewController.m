//
//  LoginViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 5/11/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "LoginViewController.h"
#import "TextFieldTableViewCell.h"
#import "AuthManager.h"

@interface LoginViewController () <AuthManagerDelegate>

@property (strong, nonatomic) AuthManager *authManager;
@property (strong, nonatomic) TextFieldTableViewCell *emailTableViewCell;
@property (strong, nonatomic) TextFieldTableViewCell *passwordTableViewCell;

@end

@implementation LoginViewController

- (instancetype)initWithAuthManager:(AuthManager *)authManager {
    self.authManager = authManager;
    self.authManager.delegate = self;
    
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
    
    self.navigationItem.title = @"Login";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.emailTableViewCell = [[TextFieldTableViewCell alloc] init];
    self.emailTableViewCell.titleLabel.text = @"Email";
    self.emailTableViewCell.textField.text = @"kruppcon@umich.edu";
    self.emailTableViewCell.textField.placeholder = @"@gmail.com";
    self.emailTableViewCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.passwordTableViewCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;

    self.passwordTableViewCell = [[TextFieldTableViewCell alloc] init];
    self.passwordTableViewCell.titleLabel.text = @"Password";
    self.passwordTableViewCell.textField.text = @"taco";
    self.passwordTableViewCell.textField.placeholder = @"hunter2";
    self.passwordTableViewCell.textField.secureTextEntry = true;
    self.passwordTableViewCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

- (void)cancel {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)saveItem {
    if ([self.emailTableViewCell.textField.text length] > 0 &&
        [self.passwordTableViewCell.textField.text length] > 0) {
        
        NSString *email = self.emailTableViewCell.textField.text;
        NSString *password = self.passwordTableViewCell.textField.text;
        
        [self.authManager loginAccountWithEmail:email password:password];
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.emailTableViewCell;
    } else if (indexPath.row == 1) {
        return self.passwordTableViewCell;
    }
    
    return nil;
}

- (void)authManager:(AuthManager *)authManager didLoginWithAccount:(MHAccount *)account {
    NSLog(@"Successfully logged in with account: %@", account);
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
