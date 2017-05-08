//
//  MHConsumedFood.h
//  Mission Health
//
//  Created by Connor Krupp on 5/4/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>

@class MHFood;
@class MHServing;
@class MHMeal;

@interface MHConsumedFood : RLMObject

@property MHFood *food;
@property (readonly) RLMLinkingObjects *meal;

@property MHServing *serving;
@property double numberOfServings;

- (double)totalCalories;
- (double)totalFat;
- (double)totalCarbs;
- (double)totalProtein;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHConsumedFood *><MHConsumedFood>
RLM_ARRAY_TYPE(MHConsumedFood)
