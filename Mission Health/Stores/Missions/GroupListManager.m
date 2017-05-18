//
//  GroupListManager.m
//  Mission Health
//
//  Created by Connor Krupp on 5/16/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "GroupListManager.h"
#import "APIManager.h"
#import "MHGroup.h"
#import "GroupManager.h"
#import "NSDate+JSONFormat.h"

@interface GroupListManager ()

@property (weak, nonatomic) APIManager  *apiManager;
@property (strong, nonatomic) NSDictionary<NSString *, NSDate *> *groupIds;

@end

@implementation GroupListManager

- (instancetype)initWithAPIManager:(APIManager *)apiManager {
    if (self = [super init]) {
        self.apiManager = apiManager;
        self.groups = [MHGroup allObjectsInRealm:[RLMRealm defaultRealm]];

        [self updateGroupIds];
    }
    
    return self;
}

// Must be called on main thread
- (void)updateGroupIds {
    NSMutableDictionary *groupIds = [[NSMutableDictionary alloc] init];
    
    for (MHGroup *group in self.groups) {
        groupIds[group.groupId] = group.lastUpdatedMetadata;
    }
    
    self.groupIds = groupIds;
}

- (GroupManager *)getGroupManagerForGroup:(MHGroup *)group {
    return [[GroupManager alloc] initWithAPIManager:self.apiManager group:group];
}

- (void)updateUserGroups {
    [self.apiManager secureTaskWithRoute:@"/users/groups" usingMethod:@"GET" withParameters:nil completion:^(NSDictionary<NSString *,id> *json) {
        if (json[@"status"]) {
            
            NSMutableArray<MHGroup *> *groupsToAdd = [[NSMutableArray alloc] init];
            NSMutableArray<NSDictionary *> *groupsToEditMetadata = [[NSMutableArray alloc] init];
            NSMutableDictionary<NSString *, NSDate *> *metadataTimestamps = [[NSMutableDictionary alloc] init];
            
            for (NSDictionary *groupData in json[@"groups"]) {
                NSString *groupId = groupData[@"_id"];
                NSString *lastUpdatedMetadataString = groupData[@"metadataUpdatedAt"];
                NSDate *lastUpdatedMetadata = [NSDate dateFromJSONString:lastUpdatedMetadataString];
                
                if (!self.groupIds[groupId]) {
                    MHGroup *group = [[MHGroup alloc] init];
                    
                    group.groupId = groupId;
                    group.name = groupData[@"name"];
                    group.isPublic = [groupData[@"isPublic"] boolValue];
                    group.lastUpdatedMetadata = lastUpdatedMetadata;
                    
                    [groupsToAdd addObject:group];
                } else if ([self.groupIds[groupId] compare:lastUpdatedMetadata] == NSOrderedAscending) {
                    [groupsToEditMetadata addObject:groupData];
                    
                    metadataTimestamps[groupId] = lastUpdatedMetadata;
                }
            }
            
            if (groupsToAdd.count > 0 || groupsToEditMetadata.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    
                    [realm transactionWithBlock:^{
                        for (MHGroup *group in groupsToAdd) {
                            [realm addObject:group];
                        }
                    
                        for (NSDictionary *groupData in groupsToEditMetadata) {
                            NSString *groupId = groupData[@"_id"];
                            MHGroup *group = [MHGroup objectForPrimaryKey:groupId];
                            
                            group.name = groupData[@"name"];
                            group.isPublic = [groupData[@"isPublic"] boolValue];
                            group.lastUpdatedMetadata = metadataTimestamps[groupId];
                        }
                    }];
                    
                    [self updateGroupIds];
                    [self.delegate groupListManagerDidFinishUpdatingGroups:self];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate groupListManagerDidFinishUpdateWithNoChanges:self];
                });
            }
        }
    }];
}

- (void)createGroup:(NSString *)name {
    NSDictionary<NSString *, id> *parameters = @{@"name": name, @"is_public": @true};
    [self.apiManager secureTaskWithRoute:@"/groups" usingMethod:@"POST" withParameters:parameters completion:^(NSDictionary<NSString *,id> *json) {
        
        [self updateUserGroups];
    }];
}

- (void)joinGroup:(NSString *)groupId {
    NSDictionary<NSString *, id> *parameters = @{@"user_id": @1};
    [self.apiManager secureTaskWithRoute:[NSString stringWithFormat:@"/groups/%@/join", groupId] usingMethod:@"POST" withParameters:parameters completion:^(NSDictionary<NSString *,id> *json) {
        
        [self updateUserGroups];
    }];
}

@end
