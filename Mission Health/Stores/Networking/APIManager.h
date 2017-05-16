//
//  APIManager.h
//  Mission Health
//
//  Created by Connor Krupp on 4/3/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHAccount;
@class AuthManager;
@class GroupManager;

@interface APIManager : NSObject

@property (strong, nonatomic) MHAccount *account;
@property (strong, nonatomic) AuthManager *authManager;
@property (strong, nonatomic) GroupManager *groupManager;

- (void)secureTaskWithRoute:(NSString *)route
                usingMethod:(NSString *)method
             withParameters:(NSDictionary<NSString *, id> *)parameters
                 completion:(void (^)(NSDictionary<NSString *, id> *))completionBlock;

+ (void)taskWithRoute:(NSString *)route
            atBaseURL:(NSURL *)baseURL
       withParameters:(NSDictionary<NSString *, id> *)parameters
          usingMethod:(NSString *)method
           completion:(void (^)(NSDictionary<NSString *, id> *))completionBlock;

+ (void)oauthTaskWithRoute:(NSString *)route
                 atBaseURL:(NSURL *)baseURL
                usingMethod:(NSString *)method
             withParameters:(NSDictionary<NSString *, id> *)parameters
            withConsumerKey:(NSString *)consumerKey
         withConsumerSecret:(NSString *)consumerSecret
           withAccessSecret:(NSString *)accessSecret
                 completion:(void (^)(NSDictionary<NSString *, id> *))completionBlock;


@end
