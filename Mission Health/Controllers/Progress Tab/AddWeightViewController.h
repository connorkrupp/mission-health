//
//  AddWeightViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 04/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHWeight;
@class AddWeightViewController;

@protocol AddWeightViewControllerDelegate <NSObject>

- (void)addWeightViewController:(AddWeightViewController *)addWeightViewController
                   didAddWeight:(MHWeight *)weight;

@end

@interface AddWeightViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id<AddWeightViewControllerDelegate> delegate;

@end
