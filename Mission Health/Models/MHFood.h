//
//  MHFood.h
//  Mission Health
//
//  Created by Connor Krupp on 2/28/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>

@interface MHFood : RLMObject

@property NSString *name;
@property NSString *brand;
@property NSString *serving;

@property double calories;
@property double fat;
@property double carbs;
@property double protein;

@property int foodId;

@property int meal;
@property NSDate *date;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHFood *><MHFood>
RLM_ARRAY_TYPE(MHFood)
