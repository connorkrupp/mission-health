//
//  PersistenceManager.h
//  Mission Health
//
//  Created by Connor Krupp on 1/30/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface PersistenceManager : NSObject

- (id)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end
