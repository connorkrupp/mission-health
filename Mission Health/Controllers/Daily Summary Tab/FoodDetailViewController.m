//
//  FoodDetailViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 4/26/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "PickerTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "MHFood.h"
#import "MHServing.h"
#import "MealManager.h"

@interface FoodDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) MealManager *mealManager;
@property (strong, nonatomic) MHFood *food;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray<NSString *> *nutritionIds;
@property (strong, nonatomic) NSDictionary<NSString *, NSNumber *> *nutrition;

@property (strong, nonatomic) MHServing *selectedServing;

@end

static const NSUInteger kServingSizeCellIndex = 0;
static const NSUInteger kServingCountCellIndex = 1;

@implementation FoodDetailViewController

- (instancetype)initWithMealManager:(MealManager *)mealManager food:(MHFood *)food {
    if (self = [super init]) {
        self.mealManager = mealManager;
        self.food = food;
        self.nutrition = [food getNutritionForServing:food.defaultServing];
        self.nutritionIds = [self.nutrition allKeys];
    }
    
    return self;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.food.servings.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.food.servings[row].desc;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedServing = self.food.servings[row];
    
    NSIndexPath *servingSizeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    PickerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:servingSizeIndexPath];
    
    cell.detailLabel.text = self.selectedServing.desc;
}

- (void)saveItem {
    self.food.meal = arc4random_uniform(3);
    
    [self.mealManager addFood:self.food inMeal:self.mealManager.meals[0]];
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2 ;//self.nutritionIds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case kServingSizeCellIndex: {
            PickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickerCell"];
            
            cell.pickerView.delegate = self;
            cell.pickerView.dataSource = self;
            cell.titleLabel.text = @"Serving Size";
            cell.detailLabel.text = self.food.defaultServing.desc;
            cell.pickerView.hidden = true;
            
            [cell.pickerView selectRow:[self indexForDefaultServing] inComponent:0 animated:false];

            return cell;
        }
        case kServingCountCellIndex: {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            
            cell.titleLabel.text = @"Number of Servings";
            cell.textField.text = @"1";
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;

            return cell;
        }
        default:
            break;
    }
    

    return [[UITableViewCell alloc] init];
}

- (NSUInteger)indexForDefaultServing {
    for (NSUInteger i = 0; i < self.food.servings.count; i++) {
        if ([self.food.servings[i].desc isEqualToString:self.food.defaultServing.desc]) {
            return i;
        }
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PickerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self.tableView beginUpdates];
    cell.pickerView.hidden = !cell.pickerView.hidden;
    [self.tableView endUpdates];
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Add Food";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[PickerTableViewCell class] forCellReuseIdentifier:@"PickerCell"];
    [self.tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:@"TextFieldCell"];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40.0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIStackView *containerStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.tableView]];
    containerStackView.axis = UILayoutConstraintAxisVertical;
    containerStackView.alignment = UIStackViewAlignmentFill;
    containerStackView.distribution = UIStackViewDistributionFill;
    containerStackView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:containerStackView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:@[

                                              [NSLayoutConstraint constraintWithItem:containerStackView
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              [NSLayoutConstraint constraintWithItem:containerStackView
                                                                           attribute:NSLayoutAttributeLeading
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view attribute:NSLayoutAttributeLeading
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              [NSLayoutConstraint constraintWithItem:containerStackView
                                                                           attribute:NSLayoutAttributeTrailing
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view attribute:NSLayoutAttributeTrailing
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              [NSLayoutConstraint constraintWithItem:containerStackView
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0
                                                                            constant:0.0]
                                              
                                              ]];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

@end
