//
//  AddWeightViewControllerDelegate.h
//  Mission Health
//
//  Created by Connor Krupp on 04/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddWeightViewController.h"
#import "MHWeight.h"

@class AddWeightViewController;

@protocol AddWeightViewControllerDelegate <NSObject>

- (void)addWeightViewController:(AddWeightViewController *)addWeightViewController
                   didAddWeight:(MHWeight *)weight;
@end
