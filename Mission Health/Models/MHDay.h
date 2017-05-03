//
//  MHDay.h
//  Mission Health
//
//  Created by Connor Krupp on 5/2/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>
#import "MHMeal.h"

@interface MHDay : RLMObject

@property NSDate *date;
@property RLMArray<MHMeal *><MHMeal> *meals;

- (instancetype)initWithDate:(NSDate *)date;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHDay *><MHDay>
RLM_ARRAY_TYPE(MHDay)
