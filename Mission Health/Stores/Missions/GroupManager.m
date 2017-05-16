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
@property (weak, nonatomic) APIManager  *apiManager;

@end

@implementation GroupManager

- (instancetype)initWithAPIManager:(APIManager *)apiManager {
    if (self = [super init]) {
        self.apiManager = apiManager;
    }
    
    return self;
}

- (void)getUserGroups {
    [self.apiManager secureTaskWithRoute:@"/user/groups" usingMethod:@"GET" withParameters:nil completion:^(NSDictionary<NSString *,id> *json) {
        if (json[@"status"]) {
            NSMutableArray *groups = [[NSMutableArray alloc] init];
            for (NSDictionary *data in json[@"groups"]) {
                MHGroup *group = [[MHGroup alloc] init];
                
                group.groupId = data[@"_id"];
                group.name = data[@"name"];
                
                for (NSString *user in data[@"members"]) {
                    MHMember *member = [[MHMember alloc] init];
                    
                    member.memberId = user;//[(NSNumber *)user[@"id"] intValue];
                    member.name = user;//[@"id"];
                    
                    [group.members addObject:member];
                }
                
                
                [groups addObject:group];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.groups = groups;
                [self.delegate groupManagerDidLoadGroups:self];
            });
        }
    }];
}

- (void)createGroup:(NSString *)name {
    NSDictionary<NSString *, id> *parameters = @{@"name": name, @"is_public": @true};
    [self.apiManager secureTaskWithRoute:@"/groups" usingMethod:@"POST" withParameters:parameters completion:^(NSDictionary<NSString *,id> *json) {
        
        [self getUserGroups];
    }];
}

- (void)joinGroup:(NSString *)groupId {
    NSDictionary<NSString *, id> *parameters = @{@"user_id": @1};
    [self.apiManager secureTaskWithRoute:[NSString stringWithFormat:@"/groups/%@/join", groupId] usingMethod:@"POST" withParameters:parameters completion:^(NSDictionary<NSString *,id> *json) {
        
        [self getUserGroups];
    }];
}

- (void)getGroupMessages:(NSString *)groupId withCount:(int)count withOffset:(int)offset {
    
}

@end
