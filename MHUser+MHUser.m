//
//  MHUser+MHUser.m
//  Mission Health
//
//  Created by Connor Krupp on 1/30/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "MHUser+MHUser.h"

@implementation MHUser (MHUser)

+ (instancetype)createUserWithEmail:(NSString *)email
                               name:(NSString *)name
             inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    MHUser *user = [self createUserInManagedObjectContext:managedObjectContext];
    
    user.email = email;
    user.name = name;
    
    return user;
}

+ (instancetype)createUserInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    MHUser *user = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                 inManagedObjectContext:managedObjectContext];
    
    return user;
}


+ (NSString *)entityName {
    return @"MHUser";
}

@end
