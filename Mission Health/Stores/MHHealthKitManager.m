//
//  MHHealthKitManager.m
//  Mission Health
//
//  Created by Connor Krupp on 5/8/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "MHHealthKitManager.h"
#import "MHWeight.h"
#import <HealthKit/HealthKit.h>

@interface MHHealthKitManager ()

@property (nonatomic, retain) HKHealthStore *healthStore;

@end

@implementation MHHealthKitManager

- (instancetype)init {
    if (self = [super init]) {
        self.healthStore = [[HKHealthStore alloc] init];
    }
    
    return self;
}

- (void)requestAuthorizationWithCompletion:(void (^)(BOOL success))completion {
    if ([HKHealthStore isHealthDataAvailable] == NO) {
        return;
    }
    
    HKObjectType *weightObjectType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKSampleType *weightSampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    NSArray *readTypes = @[weightSampleType];
    NSArray *writeTypes = @[weightObjectType];

    [self.healthStore requestAuthorizationToShareTypes:[NSSet setWithArray:writeTypes] readTypes:[NSSet setWithArray:readTypes] completion:^(BOOL success, NSError *error) {
        NSLog(@"success: %i, Error: %@", success, error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(success);
        });

    }];
}

- (void)getWeightsSinceDate:(NSDate *)date withCompletion:(void (^)(NSArray<MHWeight *> *weights))completion {
    HKSampleType *weightSampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];

    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:weightSampleType predicate:nil limit:HKObjectQueryNoLimit sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *weights = [[NSMutableArray alloc] init];
            for (HKQuantitySample *sample in results) {
                MHWeight *weight = [[MHWeight alloc] initWithWeight:[sample.quantity doubleValueForUnit:[HKUnit poundUnit]] date:sample.endDate];
                
                [weights addObject:weight];
            }
            
            completion(weights);
        });
    }];
    
    [self.healthStore executeQuery:query];

}

- (void)setWeightData:(MHWeight *)weight {
    HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass] quantity:[HKQuantity quantityWithUnit:[HKUnit poundUnit] doubleValue:weight.weight] startDate:weight.date endDate:weight.date];
    
    [self.healthStore saveObject:sample withCompletion:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success: %i, Error: %@", success, error);
    }];
}

@end
