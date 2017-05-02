//
//  DailySummaryTableSectionHeader.h
//  Mission Health
//
//  Created by Connor Krupp on 4/23/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailySummaryTableSectionHeader : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@end
