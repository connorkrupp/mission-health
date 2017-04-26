//
//  WeightHistoryManager.m
//  Mission Health
//
//  Created by Connor Krupp on 04/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "WeightHistoryManager.h"

@interface WeightHistoryManager ()

@property (strong, nonatomic) NSMutableArray<MHWeight *> *weightHistory;

@end

@implementation WeightHistoryManager

- (NSArray *)getWeightHistory {
    return self.weightHistory;
}

- (NSUInteger)getWeightHistoryCount {
    return [self.weightHistory count];
}

- (MHWeight *)getWeightDataAtIndex:(NSUInteger)index {
    if (index >= [self.weightHistory count]) {
        return nil;
    }
    
    return self.weightHistory[index];
}

- (double)getWeightChangeAtIndex:(NSUInteger)index {
    // Return 0 for last index
    if (index >= [self.weightHistory count] - 1) {
        return 0;
    }
    
    MHWeight *weight = self.weightHistory[index];
    MHWeight *pastWeight = self.weightHistory[index+1];
    
    return weight.weight - pastWeight.weight;
}

- (void)addWeightData:(MHWeight *)weight {
    long index = 0;
    for (index = 0; index < [self.weightHistory count]; ++index) {
        MHWeight *checkingWeight = self.weightHistory[index];
        if ([weight.date compare:checkingWeight.date] == NSOrderedDescending) {
            break;
        }
    }
    
    [self.weightHistory insertObject:weight atIndex:index];
    
    [self.delegate didInsertWeightData:weight at:index];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:weight];
    }];
}

- (void)removeWeightDataAtIndex:(NSUInteger)index {
    MHWeight *removedWeight = self.weightHistory[index];
    [self.weightHistory removeObjectAtIndex:index];
    
    [self.delegate didRemoveWeightData:removedWeight at:index];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObject:removedWeight];
    }];
}

- (WeightHistoryManager *)init {
    if (self = [super init]) {
        self.weightHistory = [[NSMutableArray alloc] init];
        
        RLMResults<MHWeight *> *weights = [[MHWeight allObjects] sortedResultsUsingKeyPath:@"date" ascending:false];
        
        for (MHWeight *weight in weights) {
            [self.weightHistory addObject:weight];
        }
    }

    return self;
}

@end
