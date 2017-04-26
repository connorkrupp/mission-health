//
//  WeightTableViewCell.m
//  Mission Health
//
//  Created by Connor Krupp on 04/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "WeightTableViewCell.h"
#import "UIColor+MHColors.h"

@implementation WeightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutWith:(MHWeight *)weight weightChange:(double)weightChange {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d"];

    self.dateLabel.text = [dateFormatter stringFromDate:weight.date];
    self.changeLabel.text = weightChange <= 0 ? [NSString stringWithFormat:@"%.1f", weightChange] : [NSString stringWithFormat:@"+%.1f", weightChange];
    self.changeLabel.textColor = weightChange <= 0 ? [UIColor positiveColor] : [UIColor negativeColor];
    self.weightLabel.text = [NSString stringWithFormat:@"%.1f", weight.weight];
}

@end
