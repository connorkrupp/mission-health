//
//  MHMember.h
//  Mission Health
//
//  Created by Connor Krupp on 3/14/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>

@interface MHMember : RLMObject

@property NSString *memberId;
@property NSString *name;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHMember *><MHMember>
RLM_ARRAY_TYPE(MHMember)
