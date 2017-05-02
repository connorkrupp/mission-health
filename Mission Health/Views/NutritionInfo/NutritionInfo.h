//
// Created by Connor Krupp on 4/23/17.
// Copyright (c) 2017 Connor Krupp. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NutritionInfo : UIView

@property (strong, nonatomic) IBOutlet UIProgressView *caloriesProgressView;
@property (strong, nonatomic) IBOutlet UIProgressView *fatProgressView;
@property (strong, nonatomic) IBOutlet UIProgressView *carbsProgressView;
@property (strong, nonatomic) IBOutlet UIProgressView *proteinProgressView;

@property (strong, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (strong, nonatomic) IBOutlet UILabel *fatLabel;
@property (strong, nonatomic) IBOutlet UILabel *carbsLabel;
@property (strong, nonatomic) IBOutlet UILabel *proteinLabel;


@end
