//
//  DailySummaryViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 2/7/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "DailySummaryViewController.h"

#import "FoodTableViewCell.h"

#import "DailySummaryTableSectionHeader.h"

#import "NutritionInfo.h"
#import "MealManager.h"

#import "UIColor+MHColors.h"
#import "NSString+PrettyDates.h"

@interface DailySummaryViewController ()

// Models
@property (strong, nonatomic) MealManager *mealManager;

// Views
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NutritionInfo *nutritionInfoView;

@end

@implementation DailySummaryViewController

#pragma mark - Initializers

- (instancetype)initWithMealManager:(MealManager *)mealManager {
    if (self = [super init]) {
        self.mealManager = mealManager;
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.hidesBackButton = true;
    
    NSString *titleDate = [NSString formattedStringFromDate:self.mealManager.date];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFood)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    CGFloat containerHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat containerWidth = 120;//0.95 * self.view.frame.size.width;
    UIView *titleContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerWidth, containerHeight)];
    
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevButton setFrame:CGRectMake(0, 0, 20, 44)];
    [prevButton setTitle:@"\U00002329\U0000FE0E" forState:UIControlStateNormal];
    [prevButton addTarget:self action:@selector(navigateToPreviousDay) forControlEvents:UIControlEventTouchUpInside];
    [prevButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    prevButton.titleLabel.font = [UIFont fontWithName:@"HKGrotesk-SemiBold" size:18.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 44)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:titleDate];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont fontWithName:@"HKGrotesk-SemiBold" size:18.0];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(containerWidth - 20, 0, 20, 44)];
    [nextButton setTitle:@"\U0000232A\U0000FE0E" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(navigateToNextDay) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont fontWithName:@"HKGrotesk-SemiBold" size:18.0];
    
    [titleContainer addSubview:prevButton];
    [titleContainer addSubview:nextButton];
    [titleContainer addSubview:titleLabel];
    
    //self.navigationItem.titleView = titleContainer;
    self.navigationItem.title = @"Today";
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

#pragma mark - View Updates

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

#pragma mark - Actions

- (void)addFood {
    [self.coordinator dailySummaryViewController:self didTapAddFoodWithMealManager:self.mealManager];
}

- (void)navigateToPreviousDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *prevDate = [calendar startOfDayForDate:[calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:self.mealManager.date options:NSCalendarMatchFirst]];
    
    [self.coordinator dailySummaryViewController:self didNavigateToDate:prevDate fromDate:self.mealManager.date];
}

- (void)navigateToNextDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [calendar startOfDayForDate:[calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:self.mealManager.date options:NSCalendarMatchFirst]];
    
    [self.coordinator dailySummaryViewController:self didNavigateToDate:nextDate fromDate:self.mealManager.date];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mealManager.meals.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *mealNames = @[@"Breakfast", @"Lunch", @"Dinner", @"Snacks"];
    DailySummaryTableSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableSectionHeader"];
    
    header.contentView.backgroundColor = [UIColor primaryColor];
    header.titleLabel.text = mealNames[section];
    header.detailLabel.text = [NSString stringWithFormat:@"%.0f kcals", [self.mealManager getCaloriesForMeal:self.mealManager.meals[section]]];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mealManager.meals[section].foods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    MHConsumedFood *consumedFood = self.mealManager.meals[indexPath.section].foods[indexPath.row];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setPositiveFormat:@"0"];

    NSString *cals = [formatter stringFromNumber:[NSNumber numberWithDouble:[consumedFood totalCalories]]];
    NSString *brand = consumedFood.food.brand != nil ? consumedFood.food.brand : @"Generic";
    NSString *amount = consumedFood.serving.desc;
    
    cell.titleLabel.text = consumedFood.food.name;
    cell.subtitleLabel.text = consumedFood.numberOfServings == 1 ? [NSString stringWithFormat:@"%@, %@", brand, amount] : [NSString stringWithFormat:@"%@, %.f x %@",  brand, consumedFood.numberOfServings, amount];
    cell.detailLabel.text = [cals stringByAppendingString:@" kcals"];
   
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MHConsumedFood *food = self.mealManager.meals[indexPath.section].foods[indexPath.row];
    
    [self.coordinator dailySummaryViewController:self didSelectFood:food withMealManager:self.mealManager];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        MHConsumedFood *food = self.mealManager.meals[indexPath.section].foods[indexPath.row];
        [self.mealManager removeFood:food];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [self updateNutritionInfo];
    }];
    
    return @[deleteAction];
}

@end
