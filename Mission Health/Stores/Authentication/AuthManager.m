//
//  AuthManager.m
//  Mission Health
//
//  Created by Connor Krupp on 5/11/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "AuthManager.h"
#import "APIManager.h"
#import "MHAccount.h"

static NSString *kLastAccountEmail = @"LastAccountEmail";

@interface AuthManager ()

@property (weak, nonatomic) APIManager *apiManager;

@end

@implementation AuthManager

- (instancetype)initWithAPIManager:(APIManager *)apiManager {
    if (self = [super init]) {
        self.apiManager = apiManager;
        
        NSString *lastEmail = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kLastAccountEmail];

        self.apiManager.account = [self getAccountWithEmail:lastEmail];
    }
    
    return self;
}

- (void)registerAccountWithEmail:(NSString *)email password:(NSString *)password withName:(NSString *)name {
    NSDictionary<NSString *, id> *parameters = @{@"email": email, @"password": password, @"name": name};
    [self.apiManager secureTaskWithRoute:@"/auth/register" usingMethod:@"POST" withParameters:parameters completion:^(NSDictionary<NSString *,id> *json) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([json[@"status"] isEqualToString:@"true"]) {
                MHAccount *account = [[MHAccount alloc] init];
                account.userId = json[@"id"];
                account.email = email;
                account.token = json[@"token"];
                
                [[RLMRealm defaultRealm] addObject:account];
                
                self.apiManager.account = account;
            }
        });
    }];
}

- (void)loginAccountWithEmail:(NSString *)email password:(NSString *)password {
    NSLog(@"Logging in...");
    NSDictionary<NSString *, id> *parameters = @{@"email": email, @"password": password};
    [self.apiManager secureTaskWithRoute:@"/auth/login" usingMethod:@"POST" withParameters:parameters completion:^(NSDictionary<NSString *,id> *json) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (json[@"status"]) {
                MHAccount *account = [self getAccountWithEmail:email token:json[@"token"] userId:json[@"user_id"]];
                self.apiManager.account = account;

                [self.delegate authManager:self didLoginWithAccount:account];
            }
        });
    }];
}

- (MHAccount *)getAccountWithEmail:(NSString *)email token:(NSString *)token userId:(NSString *)userId {
    MHAccount *account = [self getAccountWithEmail:email];
    
    if (account) {
        return account;
    }
    
    account = [[MHAccount alloc] init];
    account.userId = userId;
    account.email = email;
    account.token = token;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:account];
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:kLastAccountEmail];

    return account;
}

- (MHAccount *)getAccountWithEmail:(NSString *)email {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"email = %@", email];
    RLMResults<MHAccount *> *accounts = [MHAccount objectsWithPredicate:pred];
    
    if ([accounts count] > 0) {
        return accounts[0];
    }
    
    return nil;
}

@end
