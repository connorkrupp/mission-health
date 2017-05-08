//
//  FoodDetailViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 4/26/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "FoodInfoTableViewCell.h"
#import "PickerTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "NutritionInfoTableViewCell.h"
#import "MHFood.h"
#import "MHServing.h"
#import "MealManager.h"

@interface FoodDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) MealManager *mealManager;
@property (strong, nonatomic) MHConsumedFood *consumedFood;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *numberOfServingsTextField;

@property (strong, nonatomic) NSArray<NSString *> *nutritionIds;
@property (strong, nonatomic) NSDictionary<NSString *, NSNumber *> *nutrition;

@property (strong, nonatomic) MHMeal *selectedMeal;
@property (strong, nonatomic) MHServing *selectedServing;
@property (nonatomic) double selectedNumberOfServings;


@end

static const NSUInteger kFoodInfoCellIndex = 0;
static const NSUInteger kMealCellIndex = 1;
static const NSUInteger kServingSizeCellIndex = 2;
static const NSUInteger kServingCountCellIndex = 3;
static const NSUInteger kFirstNutritionCellIndex = 4;

@implementation FoodDetailViewController

- (instancetype)initWithMealManager:(MealManager *)mealManager food:(MHFood *)food {
    if (self = [super init]) {
        self.mealManager = mealManager;
        self.consumedFood = [[MHConsumedFood alloc] init];
        self.consumedFood.food = food;
        self.consumedFood.serving = food.defaultServing;
        self.consumedFood.numberOfServings = 1.0;
        self.nutrition = [food getNutritionForServing:food.defaultServing];
        self.nutritionIds = [self.nutrition allKeys];
        self.selectedServing = food.defaultServing;
        self.selectedMeal = self.mealManager.meals[0];
        self.selectedNumberOfServings = 1.0;
    }
    
    return self;
}

- (instancetype)initWithMealManager:(MealManager *)mealManager consumedFood:(MHConsumedFood *)consumedFood {
    if (self = [super init]) {
        self.mealManager = mealManager;
        self.consumedFood = consumedFood;
        self.nutrition = [consumedFood.food getNutritionForServing:consumedFood.food.defaultServing];
        self.nutritionIds = [self.nutrition allKeys];
        self.selectedServing = self.consumedFood.serving;
        self.selectedNumberOfServings = self.consumedFood.numberOfServings;
        self.selectedMeal = self.mealManager.meals[0];
    }
    
    return self;
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case kMealCellIndex: {
            return 4;
        }
        case kServingSizeCellIndex: {
            return self.consumedFood.food.servings.count;
        }
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case kMealCellIndex: {
            return [self.mealManager titleForMeal:self.mealManager.meals[row]];
        }
        case kServingSizeCellIndex: {
            return self.consumedFood.food.servings[row].desc;
        }
        default:
            break;
    }

    return nil;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case kMealCellIndex: {
            NSIndexPath *mealIndexPath = [NSIndexPath indexPathForRow:kMealCellIndex inSection:0];
            PickerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:mealIndexPath];

            self.selectedMeal = self.mealManager.meals[row];
            cell.detailLabel.text = [self.mealManager titleForMeal:self.selectedMeal];

            break;
        }
        case kServingSizeCellIndex: {
            NSIndexPath *servingSizeIndexPath = [NSIndexPath indexPathForRow:kServingSizeCellIndex inSection:0];
            PickerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:servingSizeIndexPath];
            
            self.selectedServing = self.consumedFood.food.servings[row];
            cell.detailLabel.text = self.selectedServing.desc;
            self.nutrition = [self.consumedFood.food getNutritionForServing:self.selectedServing];
            
            [self reloadNutritionCells];
            
            break;
        }
        default:
            break;
    }
}

- (void)updateNumberOfServings:(UITextField *)textField {
    self.selectedNumberOfServings = [textField.text doubleValue];
    [self reloadNutritionCells];
}

- (void)saveItem {
    if (self.consumedFood.meal.count) {
        [self.mealManager updateFood:self.consumedFood
                              toMeal:self.selectedMeal
                         withServing:self.selectedServing
                withNumberOfServings:self.selectedNumberOfServings];
        
        [self.navigationController popViewControllerAnimated:true];
    } else {
        self.consumedFood.serving = self.selectedServing;
        self.consumedFood.numberOfServings = self.selectedNumberOfServings;
        
        [self.mealManager addFood:self.consumedFood inMeal:self.selectedMeal];
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)reloadNutritionCells {
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    [indexPaths addObject:[NSIndexPath indexPathForRow:kFoodInfoCellIndex inSection:0]];
    for (NSUInteger i = kFirstNutritionCellIndex; i < self.nutritionIds.count - kFirstNutritionCellIndex - 1; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3 + self.nutritionIds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case kFoodInfoCellIndex: {
            FoodInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FoodInfoCell"];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            
            [formatter setPositiveFormat:@"0.##"];

            double scale = [self.selectedServing.amount doubleValue] / [self.consumedFood.food.defaultServing.amount doubleValue];
            NSString *cals = [formatter stringFromNumber:[NSNumber numberWithDouble:scale * self.selectedNumberOfServings * [self.consumedFood.food.calories doubleValue]]];

            cell.titleLabel.text = self.consumedFood.food.name;
            cell.subtitleLabel.text = self.consumedFood.food.brand ? self.consumedFood.food.brand : @"Generic";
            cell.detailLabel.text = [cals stringByAppendingString:@" kcals"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
        case kMealCellIndex: {
            PickerTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PickerCell"];
            
            cell.pickerView.delegate = self;
            cell.pickerView.dataSource = self;
            cell.titleLabel.text = @"Meal";
            cell.detailLabel.text = @"Breakfast";
            cell.pickerView.hidden = true;
            cell.pickerView.tag = kMealCellIndex;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        case kServingSizeCellIndex: {
            PickerTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PickerCell"];
            
            cell.pickerView.delegate = self;
            cell.pickerView.dataSource = self;
            cell.titleLabel.text = @"Serving Size";
            cell.detailLabel.text = self.selectedServing.desc;
            cell.pickerView.hidden = true;
            cell.pickerView.tag = kServingSizeCellIndex;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell.pickerView selectRow:[self indexForSelectedServing] inComponent:0 animated:false];

            return cell;
        }
        case kServingCountCellIndex: {
            TextFieldTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setPositiveFormat:@"0.##"];
            
            cell.titleLabel.text = @"Servings";
            cell.textField.text = [formatter stringFromNumber:[NSNumber numberWithDouble:self.selectedNumberOfServings]];
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            self.numberOfServingsTextField = cell.textField;
            
            UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
            UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWithTextField)];
            
            accessoryView.items = @[space, done];
            cell.textField.inputAccessoryView = accessoryView;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell.textField addTarget:self action:@selector(updateNumberOfServings:) forControlEvents:UIControlEventEditingChanged];

            return cell;
        }
        default: {
            NutritionInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NutritionCell"];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            NSString *nutritionId = self.nutritionIds[indexPath.row - kFirstNutritionCellIndex];
            
            [formatter setPositiveFormat:@"0.##"];

            cell.titleLabel.text = nutritionId;
            cell.detailLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:self.selectedNumberOfServings * [self.nutrition[nutritionId] doubleValue]]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    

    return [[UITableViewCell alloc] init];
}

- (void)doneWithTextField {
    [self.numberOfServingsTextField resignFirstResponder];
}

- (NSUInteger)indexForSelectedServing {
    for (NSUInteger i = 0; i < self.consumedFood.food.servings.count; i++) {
        if ([self.consumedFood.food.servings[i].desc isEqualToString:self.selectedServing.desc]) {
            return i;
        }
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kServingSizeCellIndex:
        case kMealCellIndex: {
            PickerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            [self.tableView beginUpdates];
            cell.pickerView.hidden = !cell.pickerView.hidden;
            [self.tableView endUpdates];
        }
        case kServingCountCellIndex: {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            
            [cell.textField becomeFirstResponder];
        }
        default:
            break;
    }
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Add Food";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.tableView = [[UITableView alloc] init];
    
    [self.tableView registerClass:[FoodInfoTableViewCell class] forCellReuseIdentifier:@"FoodInfoCell"];
    [self.tableView registerClass:[PickerTableViewCell class] forCellReuseIdentifier:@"PickerCell"];
    [self.tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:@"TextFieldCell"];
    [self.tableView registerClass:[NutritionInfoTableViewCell class] forCellReuseIdentifier:@"NutritionCell"];

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
