//
//  GroupMessageTableViewCell.h
//  Mission Health
//
//  Created by Connor Krupp on 5/16/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMessageTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *bodyLabel;
@property (strong, nonatomic) UILabel *senderLabel;
@property (strong, nonatomic) UILabel *timestampLabel;

@end
