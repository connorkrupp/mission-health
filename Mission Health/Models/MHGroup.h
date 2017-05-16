//
//  MHGroup.h
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>

#import "MHMember.h"
#import "MHMessage.h"

@interface MHGroup : RLMObject

@property NSString *groupId;
@property NSString *name;

@property RLMArray<MHMember *><MHMember> *members;

@property RLMArray<MHMessage *><MHMessage> *messages;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHGroup *><MHGroup>
RLM_ARRAY_TYPE(MHGroup)
