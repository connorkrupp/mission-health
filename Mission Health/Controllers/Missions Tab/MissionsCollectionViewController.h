//
//  MissionsCollectionViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupManager;

@interface MissionsCollectionViewController : UICollectionViewController

- (instancetype)initWithGroupManager:(GroupManager *)groupManager;

@end
