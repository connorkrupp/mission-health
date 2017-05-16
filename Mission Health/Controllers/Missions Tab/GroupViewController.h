//
//  GroupViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHGroup.h"

@class GroupManager;

@interface GroupViewController : UIViewController

- (instancetype)initWithGroupManager:(GroupManager *)groupManager group:(MHGroup *)group;

@end
