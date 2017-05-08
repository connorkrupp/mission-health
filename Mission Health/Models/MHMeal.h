//
//  MHMeal.h
//  Mission Health
//
//  Created by Connor Krupp on 5/2/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>
#import "MHConsumedFood.h"

@interface MHMeal : RLMObject

@property RLMArray<MHConsumedFood *><MHConsumedFood> *foods;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHMeal *><MHMeal>
RLM_ARRAY_TYPE(MHMeal)
