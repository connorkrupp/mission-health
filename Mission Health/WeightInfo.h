//
//  WeightInfo.h
//  Mission Health
//
//  Created by Connor Krupp on 4/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightInfo : UIView

@property (weak, nonatomic) IBOutlet UILabel *currentWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostWeightLabel;

@end
