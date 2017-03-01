//
//  MHGroup.h
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>

@interface MHGroup : RLMObject

@property int groupId;
@property NSString *name;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHGroup *><MHGroup>
RLM_ARRAY_TYPE(MHGroup)
