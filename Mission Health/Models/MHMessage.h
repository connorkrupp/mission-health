//
//  MHMessage.h
//  Mission Health
//
//  Created by Connor Krupp on 5/15/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>

@class MHMember;

@interface MHMessage : RLMObject

@property NSString *body;
@property MHMember *sender;
@property NSDate *date;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHMessage *><MHMessage>
RLM_ARRAY_TYPE(MHMessage)
