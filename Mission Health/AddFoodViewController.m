//
//  AddFoodViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 2/9/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "AddFoodViewController.h"
#import "TextFieldTableViewCell.h"

@interface AddFoodViewController ()

@property (strong, nonatomic) TextFieldTableViewCell *foodTableViewCell;
@property (strong, nonatomic) TextFieldTableViewCell *caloriesTableViewCell;
@property (strong, nonatomic) TextFieldTableViewCell *mealTableViewCell;

@property (strong, nonatomic) MealManager *mealManager;

@end

@implementation AddFoodViewController

- (instancetype)initWithMealManager:(MealManager *)mealManager {
    if (self = [super init]) {
        self.mealManager = mealManager;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Quick Add";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.foodTableViewCell = [[TextFieldTableViewCell alloc] init];
    self.foodTableViewCell.textField.placeholder = @"Food";
    self.foodTableViewCell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    self.caloriesTableViewCell = [[TextFieldTableViewCell alloc] init];
    self.caloriesTableViewCell.textField.placeholder = @"Calories";
    self.caloriesTableViewCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.mealTableViewCell = [[TextFieldTableViewCell alloc] init];
    self.mealTableViewCell.textField.placeholder = @"Meal";
    self.mealTableViewCell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    tableView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:@[
                  
          [NSLayoutConstraint constraintWithItem:tableView
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view attribute:NSLayoutAttributeTop
                                      multiplier:1.0
                                        constant:0.0],
          [NSLayoutConstraint constraintWithItem:tableView
                                       attribute:NSLayoutAttributeLeading
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view attribute:NSLayoutAttributeLeading
                                      multiplier:1.0
                                        constant:0.0],
          [NSLayoutConstraint constraintWithItem:tableView
                                       attribute:NSLayoutAttributeTrailing
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view attribute:NSLayoutAttributeTrailing
                                      multiplier:1.0
                                        constant:0.0],
          [NSLayoutConstraint constraintWithItem:tableView
                                       attribute:NSLayoutAttributeBottom
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view attribute:NSLayoutAttributeBottom
                                      multiplier:1.0
                                        constant:0.0]
              
    ]];
    
    
}

- (void)cancel {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)saveItem {
    NSString *foodName = self.foodTableViewCell.textField.text;
    double calories = self.caloriesTableViewCell.textField.text.doubleValue;
    NSString *mealName = self.mealTableViewCell.textField.text;
    
    [self.mealManager quickAddFoodWithName:foodName calories:calories inMeal:mealName];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.foodTableViewCell;
    } else if (indexPath.row == 1) {
        return self.caloriesTableViewCell;
    } else if (indexPath.row == 2) {
        return self.mealTableViewCell;
    }
    
    return nil;
}

@end
