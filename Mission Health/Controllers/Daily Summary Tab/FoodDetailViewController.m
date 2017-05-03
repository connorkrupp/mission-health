//
//  FoodDetailViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 4/26/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "PickerTableViewCell.h"

@interface FoodDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) MealManager *mealManager;
@property (strong, nonatomic) MHFood *food;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray<NSString *> *nutritionIds;
@property (strong, nonatomic) NSDictionary<NSString *, NSNumber *> *nutrition;

@end

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

- (void)saveItem {
    /*
     AddFoodViewController *addFoodViewController = [[AddFoodViewController alloc] initWithMealManager:self.mealManager];
     UINavigationController *addFoodNavigationController = [[UINavigationController alloc] initWithRootViewController:addFoodViewController];
     
     [self presentViewController:addFoodNavigationController animated:true completion:nil];
     */
    self.food.meal = arc4random_uniform(3);
    
    [self.mealManager addFood:self.food inMeal:self.mealManager.meals[0]];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//self.nutritionIds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickerCell"];
    
    cell.titleLabel.text = @"Serving Size";
    cell.detailLabel.text = @"1 ounce";
    
    return cell;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Add Food";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[PickerTableViewCell class] forCellReuseIdentifier:@"PickerCell"];
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
