//
//  MHWeight.h
//  Mission Health
//
//  Created by Connor Krupp on 4/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>

@interface MHWeight : RLMObject

@property double weight;
@property NSDate *date;

- (instancetype)initWithWeight:(double)weight date:(NSDate *)date;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHWeight *><MHWeight>
RLM_ARRAY_TYPE(MHWeight)
