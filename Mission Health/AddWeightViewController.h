//
//  AddWeightViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 04/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddWeightViewControllerDelegate.h"

@protocol AddWeightViewControllerDelegate;

@interface AddWeightViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id<AddWeightViewControllerDelegate> delegate;

@end
