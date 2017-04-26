//
//  WeightSummaryViewController.h
//  Mission Health
//
//  Created by Connor Krupp on 04/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddWeightViewControllerDelegate.h"
#import "WeightHistoryManager.h"
#import "WeightHistoryManagerDelegate.h"
#import "WeightInfo.h"

@interface WeightSummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddWeightViewControllerDelegate, WeightHistoryManagerDelegate>

@property (strong, nonatomic) WeightInfo *weightInfoView;

@property (strong, nonatomic) UITableView *weightsTableView;

@property (strong, nonatomic) WeightHistoryManager *weightHistoryManager;

@end
