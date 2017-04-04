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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *mealNames = @[@"breakfast", @"lunch", @"dinner", @"snacks"];
    
    return mealNames[section];
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
    
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.tableView registerClass:[FoodTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80.0;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

@end
