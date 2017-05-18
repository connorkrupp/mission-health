//
//  GroupManager.h
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APIManager;
@class GroupManager;
@class MHGroup;
@class MHMember;

@protocol GroupManagerDelegate <NSObject>

- (void)groupManagerDidLoadMessages:(GroupManager *)groupManager;
- (void)groupManagerDidLoadMessagesWithNoChanges:(GroupManager *)groupManager;

@end

@interface GroupManager : NSObject

@property (strong, nonatomic) MHGroup *group;
@property (weak, nonatomic) id<GroupManagerDelegate> delegate;

- (instancetype)initWithAPIManager:(APIManager *)apiManager group:(MHGroup *)group;

- (void)reloadGroupMessages;
- (void)composeMessageWithBody:(NSString *)body;

@end
