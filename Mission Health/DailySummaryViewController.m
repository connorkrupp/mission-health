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

@interface DailySummaryViewController ()

@property (strong, nonatomic) MealManager *mealManager;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation DailySummaryViewController

- (instancetype)initWithMealManager:(MealManager *)mealManager {
    if (self = [super init]) {
        self.mealManager = mealManager;
    }
    
    return self;
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
    
    header.titleLabel.text = mealNames[section];
    
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
    cell.detailLabel.text = [NSString stringWithFormat:@"%.f", food.calories];
    
    return cell;
}


- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Today";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    
    self.navigationItem.rightBarButtonItem = addButton;

    UIView *nutritionInfoView = [[NutritionInfo alloc] init];

    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.tableView registerClass:[FoodTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DailySummaryTableSectionHeader" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"TableSectionHeader"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80.0;
    tableView.dataSource = self;
    tableView.delegate = self;

    UIStackView *containerStackView = [[UIStackView alloc] initWithArrangedSubviews:@[nutritionInfoView, tableView]];
    containerStackView.axis = UILayoutConstraintAxisVertical;
    containerStackView.alignment = UIStackViewAlignmentFill;
    containerStackView.distribution = UIStackViewDistributionFill;
    containerStackView.translatesAutoresizingMaskIntoConstraints = false;

    [self.view addSubview:containerStackView];
    
    tableView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:@[

        [NSLayoutConstraint constraintWithItem:nutritionInfoView
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
}

@end
