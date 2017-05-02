//
//  MHServing.h
//  Mission Health
//
//  Created by Connor Krupp on 4/26/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>

@interface MHServing : RLMObject

@property NSString *desc;

// Some foods only have descriptions
@property NSNumber<RLMDouble> *amount;
@property NSNumber<RLMInt> *unit;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHServing *><MHServing>
RLM_ARRAY_TYPE(MHServing)
