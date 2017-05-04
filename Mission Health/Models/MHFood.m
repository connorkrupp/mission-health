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
    
    [self setValue:self.calories forKey:@"Calories" inDict:nutrition forServing:serving];
    [self setValue:self.fat forKey:@"Fat" inDict:nutrition forServing:serving];
    [self setValue:self.carbs forKey:@"Carbs" inDict:nutrition forServing:serving];
    [self setValue:self.protein forKey:@"Protein" inDict:nutrition forServing:serving];
    [self setValue:self.saturatedFat forKey:@"Saturated Fat" inDict:nutrition forServing:serving];
    [self setValue:self.polyunsaturatedFat forKey:@"Polyunsaturated Fat" inDict:nutrition forServing:serving];
    [self setValue:self.monounsaturatedFat forKey:@"Monounsaturated Fat" inDict:nutrition forServing:serving];
    [self setValue:self.transFat forKey:@"Trans Fat" inDict:nutrition forServing:serving];
    [self setValue:self.cholesterol forKey:@"Cholesterol" inDict:nutrition forServing:serving];
    [self setValue:self.sodium forKey:@"Sodium" inDict:nutrition forServing:serving];
    [self setValue:self.potassium forKey:@"Potassium" inDict:nutrition forServing:serving];
    [self setValue:self.fiber forKey:@"Fiber" inDict:nutrition forServing:serving];
    [self setValue:self.sugar forKey:@"Sugar" inDict:nutrition forServing:serving];
    [self setValue:self.vitaminA forKey:@"Vitamin A" inDict:nutrition forServing:serving];
    [self setValue:self.vitaminC forKey:@"Vitamin C" inDict:nutrition forServing:serving];
    [self setValue:self.calcium forKey:@"Calcium" inDict:nutrition forServing:serving];
    [self setValue:self.iron forKey:@"Iron" inDict:nutrition forServing:serving];

    return nutrition;
}

- (void)setValue:(NSNumber<RLMDouble> *)value forKey:(NSString *)key inDict:(NSMutableDictionary *)dict forServing:(MHServing *)serving {
    if (value) {
        
        double scale = [serving.amount doubleValue] / [self.defaultServing.amount doubleValue];
        
        dict[key] = [NSNumber numberWithDouble:scale * [value doubleValue]];
    }
}

@end
