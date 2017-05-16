//
//  AuthManager.h
//  Mission Health
//
//  Created by Connor Krupp on 5/11/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"

@class AuthManager;

@protocol AuthManagerDelegate <NSObject>

- (void)authManager:(AuthManager *)authManager didLoginWithAccount:(MHAccount *)account;

@end

@interface AuthManager : NSObject

@property (weak, nonatomic) id<AuthManagerDelegate> delegate;

- (instancetype)initWithAPIManager:(APIManager *)apiManager;
- (void)loginAccountWithEmail:(NSString *)email password:(NSString *)password;

@end
