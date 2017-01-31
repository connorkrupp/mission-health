//
//  Store.h
//  Mission Health
//
//  Created by Connor Krupp on 1/30/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

@import Foundation;


@class MHUser;

@interface Store : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (MHUser *)lastUser;

@end
