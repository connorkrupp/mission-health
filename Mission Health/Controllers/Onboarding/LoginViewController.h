//
//  LoginViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 5/11/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuthManager;

@interface LoginViewController : UITableViewController

- (instancetype)initWithAuthManager:(AuthManager *)authManager;

@end
