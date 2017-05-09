//
//  MHHealthKitManager.h
//  Mission Health
//
//  Created by Connor Krupp on 5/8/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHWeight;

@interface MHHealthKitManager : NSObject

- (void)requestAuthorizationWithCompletion:(void (^)(BOOL success))completion;

- (void)getWeightsSinceDate:(NSDate *)date withCompletion:(void (^)(NSArray<MHWeight *> *weights))completion;
- (void)setWeightData:(MHWeight *)weight;

@end
