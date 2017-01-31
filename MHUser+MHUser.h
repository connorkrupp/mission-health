//
//  MHUser+MHUser.h
//  Mission Health
//
//  Created by Connor Krupp on 1/30/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "MHUser+CoreDataClass.h"

@interface MHUser (MHUser)

+ (instancetype)createUserWithEmail:(NSString *)email
                               name:(NSString *)name
             inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (instancetype)createUserInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
