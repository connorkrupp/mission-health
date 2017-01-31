//
//  PersistenceManager.m
//  Mission Health
//
//  Created by Connor Krupp on 1/30/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "PersistenceManager.h"

@interface PersistenceManager ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSURL *modelURL;
@property (nonatomic, strong) NSURL *storeURL;

@end

@implementation PersistenceManager

- (id)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL {
    if (self = [super init]) {
        self.storeURL = storeURL;
        self.modelURL = modelURL;
        [self setupManagedObjectContext];
    }

    return self;
}

- (void)setupManagedObjectContext {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError *error;
    
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                       configuration:nil
                                                                                 URL:self.storeURL
                                                                             options:nil
                                                                               error:&error];
    
    if (error) {
        NSLog(@"Error in managedObjectContext Setup: %@", error);
    }
}

- (NSManagedObjectModel *)managedObjectModel {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

@end
