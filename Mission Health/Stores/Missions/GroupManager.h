//
//  GroupManager.h
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHGroup.h"
#import "MHMember.h"

@class APIManager;
@class GroupManager;

@protocol GroupManagerDelegate <NSObject>

- (void)groupManagerDidLoadGroups:(GroupManager *)groupManager;

@end

@interface GroupManager : NSObject

@property (strong, nonatomic) NSArray<MHGroup *> *groups;
@property (weak, nonatomic) id<GroupManagerDelegate> delegate;

//@property (strong, nonatomic) NSArrayNSArray *> *groups;

- (instancetype)initWithAPIManager:(APIManager *)apiManager;

- (void)getUserGroups;
- (void)createGroup:(NSString *)name;
- (void)joinGroup:(NSString *)groupId;
- (void)getGroupMessages:(NSString *)groupId withCount:(int)count withOffset:(int)offset;

@end
