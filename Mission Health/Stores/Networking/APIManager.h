//
//  APIManager.h
//  Mission Health
//
//  Created by Connor Krupp on 4/3/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (void)taskWithRoute:(NSString *)route atBaseURL:(NSURL *)baseURL parameters:(NSDictionary<NSString *, id> *)parameters usingMethod:(NSString *)method completion:(void (^)(NSDictionary<NSString *, id> *))completionBlock;

+ (void)secureTaskWithRoute:(NSString *)route
                  atBaseURL:(NSURL *)baseURL
                usingMethod:(NSString *)method
             withParameters:(NSDictionary<NSString *, id> *)parameters
            withConsumerKey:(NSString *)consumerKey
         withConsumerSecret:(NSString *)consumerSecret
           withAccessSecret:(NSString *)accessSecret
                 completion:(void (^)(NSDictionary<NSString *, id> *))completionBlock;
@end
