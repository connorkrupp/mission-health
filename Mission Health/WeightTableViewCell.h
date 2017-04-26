//
//  WeightTableViewCell.h
//  Mission Health
//
//  Created by Connor Krupp on 04/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHWeight.h"

@interface WeightTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

- (void)layoutWith:(MHWeight *)weight weightChange:(double)weightChange;

@end
