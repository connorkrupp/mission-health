//
//  FoodSearchViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 4/3/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "FoodSearchViewController.h"
#import "FoodTableViewCell.h"
#import "MHFood.h"
#import "MealManager.h"

@interface FoodSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MealManagerSearchDelegate>

@property (strong, nonatomic) MealManager *mealManager;
@property (strong, nonatomic) UITableView *resultsTableView;

@end

@implementation FoodSearchViewController

#pragma mark - Initializers

- (instancetype)initWithMealManager:(MealManager *)mealManager {
    if (self = [super init]) {
        self.mealManager = mealManager;
        self.mealManager.searchDelegate = self;
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView {
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Food Search";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(quickAdd)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"Food Search";

    self.resultsTableView = [[UITableView alloc] init];
    self.resultsTableView.dataSource = self;
    self.resultsTableView.delegate = self;
    self.resultsTableView.rowHeight = UITableViewAutomaticDimension;
    self.resultsTableView.estimatedRowHeight = 60.0;
    
    [self.resultsTableView registerClass:[FoodTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIStackView *containerStackView = [[UIStackView alloc] initWithArrangedSubviews:@[searchBar, self.resultsTableView]];
    containerStackView.translatesAutoresizingMaskIntoConstraints = false;
    
    containerStackView.axis = UILayoutConstraintAxisVertical;
    
    [self.view addSubview:containerStackView];
    
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
                                          toItem:self.view attribute:NSLayoutAttributeBottom
                                      multiplier:1.0
                                        constant:0.0]
              
    ]];
}

#pragma mark - Actions

- (void)cancel {
    [self.mealManager didCancelSearch];
    [self.coordinator foodSearchViewControllerDidCancel:self];
}

- (void)quickAdd {
    [self.coordinator foodSearchViewController:self didTapQuickAddWithMealManager:self.mealManager];
}

#pragma mark - MealManagerDelegate

- (void)mealManagerDidFinishSearch:(MealManager *)mealManager {
    NSLog(@"Reloading");
    if (mealManager.searchResults.count == 0) {
        self.resultsTableView.hidden = true;
    } else {
        self.resultsTableView.hidden = false;
        [self.resultsTableView reloadData];
    }
}

- (void)mealManager:(MealManager *)mealManager didFinishGettingDetailsForFood:(MHFood *)food {
    [self.coordinator foodSearchViewController:self didGetDetailsForFood:food withMealManager:self.mealManager];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mealManager.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    MHFood *food = self.mealManager.searchResults[indexPath.row];
    
    cell.titleLabel.text = food.name;
    cell.subtitleLabel.text = food.brand != nil ? food.brand : @"Generic";
    cell.detailLabel.text = [NSString stringWithFormat:@"%@", food.calories];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MHFood *food = self.mealManager.searchResults[indexPath.row];
    
    [self.mealManager getDetailsForFood:food];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Searching");
    [self.mealManager searchFoodsWithExpression:searchBar.text];
}

@end
