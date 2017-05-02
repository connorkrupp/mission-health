//
//  DailySummaryViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 2/7/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "DailySummaryViewController.h"
#import "AddFoodViewController.h"
#import "FoodSearchViewController.h"
#import "FoodTableViewCell.h"
#import "NutritionInfo.h"
#import "DailySummaryTableSectionHeader.h"
#import "UIColor+MHColors.h"
#import "FoodDetailViewController.h"

@interface DailySummaryViewController ()

@property (strong, nonatomic) MealManager *mealManager;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NutritionInfo *nutritionInfoView;

@end

@implementation DailySummaryViewController

- (instancetype)initWithMealManager:(MealManager *)mealManager {
    if (self = [super init]) {
        self.mealManager = mealManager;
    }
    
    return self;
}

- (void)updateNutritionInfo {
    double calorieLimit = 2000;
    double fatLimit = 60;
    double carbLimit = 275;
    double proteinLimit = 70;
    
    double calorieProgress = [self.mealManager getTotalCalories];
    double fatProgress = [self.mealManager getTotalFat];
    double carbProgress = [self.mealManager getTotalCarbs];
    double proteinProgress = [self.mealManager getTotalProtein];
    
    self.nutritionInfoView.caloriesLabel.text = [NSString stringWithFormat:@"%.f remaining", calorieLimit - calorieProgress];
    self.nutritionInfoView.fatLabel.text = [NSString stringWithFormat:@"%.fg left", fatLimit - fatProgress];
    self.nutritionInfoView.carbsLabel.text = [NSString stringWithFormat:@"%.fg left", carbLimit - carbProgress];
    self.nutritionInfoView.proteinLabel.text = [NSString stringWithFormat:@"%.fg left", proteinLimit - proteinProgress];

    self.nutritionInfoView.caloriesProgressView.progress = calorieProgress/calorieLimit;
    self.nutritionInfoView.fatProgressView.progress = fatProgress/fatLimit;
    self.nutritionInfoView.carbsProgressView.progress = carbProgress/carbLimit;
    self.nutritionInfoView.proteinProgressView.progress = proteinProgress/proteinLimit;
}

- (void)addItem {
    /*
    AddFoodViewController *addFoodViewController = [[AddFoodViewController alloc] initWithMealManager:self.mealManager];
    UINavigationController *addFoodNavigationController = [[UINavigationController alloc] initWithRootViewController:addFoodViewController];
    
    [self presentViewController:addFoodNavigationController animated:true completion:nil];
     */
    FoodSearchViewController *foodSearchViewController = [[FoodSearchViewController alloc] initWithMealManager:self.mealManager];
    
    UINavigationController *addFoodNavigationController = [[UINavigationController alloc] initWithRootViewController:foodSearchViewController];
    
    [self presentViewController:addFoodNavigationController animated:true completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mealManager.meals.count;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        NSArray *mealNames = @[@"Breakfast", @"Lunch", @"Dinner", @"Snacks"];
    return mealNames[section];
}
*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *mealNames = @[@"Breakfast", @"Lunch", @"Dinner", @"Snacks"];
    
    DailySummaryTableSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableSectionHeader"];
    header.contentView.backgroundColor = [UIColor primaryColor];
    header.titleLabel.text = mealNames[section];
    header.detailLabel.text = [NSString stringWithFormat:@"%.0f", [self.mealManager getCaloriesForMeal:section]];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mealManager.meals[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    MHFood *food = self.mealManager.meals[indexPath.section][indexPath.row];
    
    cell.titleLabel.text = food.name;
    cell.subtitleLabel.text = food.brand != nil ? food.brand : @"Generic";
    cell.detailLabel.text = [NSString stringWithFormat:@"%@", food.calories];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MHFood *food = self.mealManager.meals[indexPath.section][indexPath.row];
    FoodDetailViewController *foodDetailViewController = [[FoodDetailViewController alloc] initWithMealManager:self.mealManager food:food];
    
    [self.navigationController pushViewController:foodDetailViewController animated:true];
}


- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Today";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    
    self.navigationItem.rightBarButtonItem = addButton;

    self.nutritionInfoView = [[NutritionInfo alloc] init];

    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[FoodTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DailySummaryTableSectionHeader" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"TableSectionHeader"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    UIStackView *containerStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.nutritionInfoView, self.tableView]];
    containerStackView.axis = UILayoutConstraintAxisVertical;
    containerStackView.alignment = UIStackViewAlignmentFill;
    containerStackView.distribution = UIStackViewDistributionFill;
    containerStackView.translatesAutoresizingMaskIntoConstraints = false;

    [self.view addSubview:containerStackView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:@[

        [NSLayoutConstraint constraintWithItem:self.nutritionInfoView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:160.0],
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
    [self updateNutritionInfo];
}

@end
