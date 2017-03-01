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
@property int meal;
@property double calories;
@property NSDate *date;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHFood *><MHFood>
RLM_ARRAY_TYPE(MHFood)
