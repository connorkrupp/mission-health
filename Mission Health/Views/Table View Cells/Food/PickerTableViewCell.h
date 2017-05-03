//
//  PickerTableViewCell.h
//  Mission Health
//
//  Created by Connor Krupp on 5/2/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIPickerView *pickerView;

@end
