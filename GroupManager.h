//
//  GroupManager.h
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHGroup.h"

@class GroupManager;

@protocol GroupManagerDelegate <NSObject>

- (void)groupManagerDidLoadGroups:(GroupManager *)groupManager;

@end

@interface GroupManager : NSObject

@property (strong, nonatomic) NSArray<MHGroup *> *groups;
@property (weak, nonatomic) id<GroupManagerDelegate> delegate;

- (void)getGroups;
- (void)createGroup:(NSString *)name;
- (void)joinGroup:(int)groupId;

@end
