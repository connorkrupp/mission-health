//
//  GroupManager.m
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "GroupManager.h"
#import "APIManager.h"

@interface GroupManager ()

@property (strong, nonatomic) NSURL *baseURL;

@end


@implementation GroupManager


- (instancetype)init {
    if (self = [super init]) {
        
#if TARGET_IPHONE_SIMULATOR
        self.baseURL = [[NSURL alloc] initWithString:@"http://localhost:3000/api"];
#else
        self.baseURL = [[NSURL alloc] initWithString:@"http://mission-health.herokuapp.com/api"];
#endif
    }
    
    return self;
}

- (void)getGroups {
    [APIManager taskWithRoute:@"/users/1/groups" atBaseURL:self.baseURL parameters:nil usingMethod:@"GET" completion:^(NSDictionary<NSString *,id> *json) {
        
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        for (NSDictionary *data in json[@"data"]) {
            MHGroup *group = [[MHGroup alloc] init];
              
            group.groupId = [(NSNumber *)data[@"group_id"] intValue];
            group.name = data[@"name"];
            
            for (NSDictionary *user in data[@"users"]) {
                MHMember *member = [[MHMember alloc] init];
                
                member.memberId = [(NSNumber *)user[@"id"] intValue];
                member.name = user[@"name"];
                
                [group.members addObject:member];
            }
            
              
            [groups addObject:group];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.groups = groups;
            [self.delegate groupManagerDidLoadGroups:self];
        });
    }];
}

- (void)createGroup:(NSString *)name {
    NSDictionary<NSString *, id> *parameters = @{@"name": name, @"user_id": @1};
    [APIManager taskWithRoute:@"/groups" atBaseURL:self.baseURL parameters:parameters usingMethod:@"POST" completion:^(NSDictionary<NSString *,id> *json) {
        
        [self getGroups];
    }];
}

- (void)joinGroup:(int)groupId {
    NSDictionary<NSString *, id> *parameters = @{@"user_id": @1};
    [APIManager taskWithRoute:[NSString stringWithFormat:@"/groups/%d/join", groupId] atBaseURL:self.baseURL parameters:parameters usingMethod:@"POST" completion:^(NSDictionary<NSString *,id> *json) {
        
        [self getGroups];
    }];
}

@end
