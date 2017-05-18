//
//  GroupListManager.h
//  Mission Health
//
//  Created by Connor Krupp on 5/16/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHGroup.h"

@class MHMember;
@class APIManager;
@class GroupListManager;
@class GroupManager;

@protocol GroupListManagerDelegate <NSObject>

- (void)groupListManagerDidFinishUpdateWithNoChanges:(GroupListManager *)groupListManager;
- (void)groupListManagerDidFinishUpdatingGroups:(GroupListManager *)groupManager;


@end

@interface GroupListManager : NSObject

@property (strong, nonatomic) RLMResults<MHGroup *> *groups;
@property (weak, nonatomic) id<GroupListManagerDelegate> delegate;

- (instancetype)initWithAPIManager:(APIManager *)apiManager;

- (GroupManager *)getGroupManagerForGroup:(MHGroup *)group;
- (void)updateUserGroups;
- (void)createGroup:(NSString *)name;
- (void)joinGroup:(NSString *)groupId;

@end
