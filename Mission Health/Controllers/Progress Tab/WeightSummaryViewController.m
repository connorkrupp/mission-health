//
//  WeightSummaryViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 04/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "WeightSummaryViewController.h"
#import "WeightTableViewCell.h"
#import "MHWeight.h"
#import "AddWeightViewController.h"
#import "UIColor+MHColors.h"

@implementation WeightSummaryViewController

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Weight";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWeight:)];
    
    self.weightInfoView = [[WeightInfo alloc] init];
    
    self.weightsTableView = [[UITableView alloc] init];
    self.weightsTableView.delegate = self;
    self.weightsTableView.dataSource = self;
    self.weightsTableView.estimatedRowHeight = 100;
    self.weightsTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.weightsTableView registerNib:[UINib nibWithNibName:@"WeightTableViewCell" bundle:nil] forCellReuseIdentifier:@"WeightCell"];

    UIStackView *containerStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.weightInfoView, self.weightsTableView]];
    containerStackView.axis = UILayoutConstraintAxisVertical;
    containerStackView.alignment = UIStackViewAlignmentFill;
    containerStackView.distribution = UIStackViewDistributionFill;
    containerStackView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:containerStackView];
    
    self.weightsTableView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:@[
                                              
                                              [NSLayoutConstraint constraintWithItem:self.weightInfoView
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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.weightHistoryManager = [[WeightHistoryManager alloc] init];
    self.weightHistoryManager.delegate = self;
    
    [self updateWeightSummary];
}

- (void)didInsertWeightData:(MHWeight *)weight at:(NSUInteger)index {
    NSIndexPath *newWeightIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.weightsTableView insertRowsAtIndexPaths:@[newWeightIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (index == 0) {
        // Only updates header if it is the most recent weight
        [self updateWeightSummary];
    } else {
        // Cell before new cell shows difference in weight, so must reload that cell to recalculate weight change
        NSIndexPath *dependentWeightIndexPath = [NSIndexPath indexPathForRow:index - 1 inSection:0];
        [self.weightsTableView reloadRowsAtIndexPaths:@[dependentWeightIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)didRemoveWeightData:(MHWeight *)weight at:(NSUInteger)index {
    NSIndexPath *removedWeightIndexPath = [NSIndexPath indexPathForRow:index inSection:0];

    [self.weightsTableView deleteRowsAtIndexPaths:@[removedWeightIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (index == 0) {
        // Only updates header if it is the most recent weight
        [self updateWeightSummary];
    } else {
        // Cell before new cell shows difference in weight, so must reload that cell to recalculate weight change
        NSIndexPath *dependentWeightIndexPath = [NSIndexPath indexPathForRow:index - 1 inSection:0];
        [self.weightsTableView reloadRowsAtIndexPaths:@[dependentWeightIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}

- (void)updateWeightSummary {
    MHWeight *currentWeight = [self.weightHistoryManager getWeightDataAtIndex:0];
    self.weightInfoView.currentWeightLabel.text = currentWeight ? [NSString stringWithFormat:@"%.1f", currentWeight.weight] : @"---";
    
    double startWeight = 250.0;
    double goalWeight = 180.0;
    
    self.weightInfoView.lostWeightLabel.text = isnan(startWeight) ? @"---" : [NSString stringWithFormat:@"%.1f", startWeight - currentWeight.weight];
    
    self.weightInfoView.remainingWeightLabel.text = isnan(goalWeight) ? @"---" : [NSString stringWithFormat:@"%.1f", -(goalWeight - currentWeight.weight)];
}

# pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Weight History";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.weightHistoryManager getWeightHistoryCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeightCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[WeightTableViewCell alloc] init];
    }
    
    MHWeight *weight = [self.weightHistoryManager getWeightDataAtIndex:indexPath.row];
    double weightChange = [self.weightHistoryManager getWeightChangeAtIndex:indexPath.row];
    
    [cell layoutWith:weight weightChange:weightChange];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [self.weightHistoryManager removeWeightDataAtIndex:indexPath.row];
    }];
    
    return @[deleteAction];
}

# pragma mark - AddWeightViewControllerDelegate

- (void)addWeightViewController:(AddWeightViewController *)addWeightViewController
                   didAddWeight:(MHWeight *)weight {
    
    [self.weightHistoryManager addWeightData:weight];
}

- (void)addWeight:(UIBarButtonItem *)sender {
    AddWeightViewController *addWeightViewController = [[AddWeightViewController alloc] init];
    addWeightViewController.delegate = self;
    UINavigationController *addWeightNavigationController = [[UINavigationController alloc] initWithRootViewController:addWeightViewController];
        
    [self.navigationController presentViewController:addWeightNavigationController animated:true completion:nil];
}

@end
