//
//  WeightHistoryManagerDelegate.h
//  Mission Health
//
//  Created by Connor Krupp on 04/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHWeight.h"

@protocol WeightHistoryManagerDelegate <NSObject>

- (void)didInsertWeightData:(MHWeight *)weight at:(NSUInteger)index;
- (void)didRemoveWeightData:(MHWeight *)weight at:(NSUInteger)index;

@end
