//
//  Store.m
//  Mission Health
//
//  Created by Connor Krupp on 1/30/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

@import CoreData;

#import "Store.h"
#import "MHUser+MHUser.h"
#import "MHUser+CoreDataClass.h"

@implementation Store

- (MHUser *)lastUser {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MHUser"];
    NSArray *users = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    MHUser *user = [users lastObject];
    
    if (user == nil) {
        user = [MHUser createUserInManagedObjectContext:self.managedObjectContext];
    }
    
    return user;
}

@end
