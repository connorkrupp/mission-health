//
//  MHFood.h
//  Mission Health
//
//  Created by Connor Krupp on 2/28/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Realm/Realm.h>
#import "MHServing.h"

@interface MHFood : RLMObject

@property NSString *name;
@property NSString *brand;
@property NSString *serving;

@property NSNumber<RLMDouble> *calories;
@property NSNumber<RLMDouble> *fat;
@property NSNumber<RLMDouble> *carbs;
@property NSNumber<RLMDouble> *protein;
@property NSNumber<RLMDouble> *saturatedFat;
@property NSNumber<RLMDouble> *polyunsaturatedFat;
@property NSNumber<RLMDouble> *monounsaturatedFat;
@property NSNumber<RLMDouble> *transFat;
@property NSNumber<RLMDouble> *cholesterol;
@property NSNumber<RLMDouble> *sodium;
@property NSNumber<RLMDouble> *potassium;
@property NSNumber<RLMDouble> *fiber;
@property NSNumber<RLMDouble> *sugar;
@property NSNumber<RLMDouble> *vitaminA;
@property NSNumber<RLMDouble> *vitaminC;
@property NSNumber<RLMDouble> *calcium;
@property NSNumber<RLMDouble> *iron;

@property MHServing *defaultServing;
@property RLMArray<MHServing *><MHServing> *servings;

@property int foodId;

@property int meal;
@property NSDate *date;

- (NSDictionary<NSString *, NSNumber *> *)getNutritionForServing:(MHServing *)serving;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MHFood *><MHFood>
RLM_ARRAY_TYPE(MHFood)
