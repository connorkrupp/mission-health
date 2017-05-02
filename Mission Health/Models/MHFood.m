//
//  MHFood.m
//  Mission Health
//
//  Created by Connor Krupp on 2/28/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "MHFood.h"

@implementation MHFood

- (NSDictionary<NSString *, NSNumber *> *)getNutritionForServing:(MHServing *)serving {
    NSMutableDictionary<NSString *, NSNumber *> *nutrition = [[NSMutableDictionary alloc] init];
    
    [self setValue:self.calories forKey:@"Calories" inDict:nutrition];
    [self setValue:self.fat forKey:@"Fat" inDict:nutrition];
    [self setValue:self.carbs forKey:@"Carbs" inDict:nutrition];
    [self setValue:self.protein forKey:@"Protein" inDict:nutrition];
    [self setValue:self.saturatedFat forKey:@"Saturated Fat" inDict:nutrition];
    [self setValue:self.polyunsaturatedFat forKey:@"Polyunsaturated Fat" inDict:nutrition];
    [self setValue:self.monounsaturatedFat forKey:@"Monounsaturated Fat" inDict:nutrition];
    [self setValue:self.transFat forKey:@"Trans Fat" inDict:nutrition];
    [self setValue:self.cholesterol forKey:@"Cholesterol" inDict:nutrition];
    [self setValue:self.sodium forKey:@"Sodium" inDict:nutrition];
    [self setValue:self.potassium forKey:@"Potassium" inDict:nutrition];
    [self setValue:self.fiber forKey:@"Fiber" inDict:nutrition];
    [self setValue:self.sugar forKey:@"Sugar" inDict:nutrition];
    [self setValue:self.vitaminA forKey:@"Vitamin A" inDict:nutrition];
    [self setValue:self.vitaminC forKey:@"Vitamin C" inDict:nutrition];
    [self setValue:self.calcium forKey:@"Calcium" inDict:nutrition];
    [self setValue:self.iron forKey:@"Iron" inDict:nutrition];

    return nutrition;
}

- (void)setValue:(NSNumber<RLMDouble> *)value forKey:(NSString *)key inDict:(NSMutableDictionary *)dict {
    if (value) {
        dict[key] = value;
    }
}

@end
