//
//  WeightHistoryManager.h
//  Mission Health
//
//  Created by Connor Krupp on 04/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeightHistoryManagerDelegate.h"
#import "MHWeight.h"

@interface WeightHistoryManager : NSObject

@property (weak, nonatomic) id<WeightHistoryManagerDelegate> delegate;

- (double)getWeightChangeAtIndex:(NSUInteger)index;
- (NSUInteger)getWeightHistoryCount;
- (MHWeight *)getWeightDataAtIndex:(NSUInteger)index;
- (NSArray *)getWeightHistory;
- (void)addWeightData:(MHWeight *)weight;
- (void)removeWeightDataAtIndex:(NSUInteger)index;

@end
