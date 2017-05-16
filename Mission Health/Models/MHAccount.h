//
//  MHAccount.h
//  Mission Health
//
//  Created by Connor Krupp on 5/11/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>

@interface MHAccount : RLMObject

@property NSString *email;
@property NSString *name;
@property NSString *userId;
@property NSString *token;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHAccount *><MHAccount>
RLM_ARRAY_TYPE(MHAccount)
