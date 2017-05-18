//
//  MissionsCollectionViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "MissionsCollectionViewController.h"
#import "MissionsCollectionViewCell.h"
#import "AddGroupViewController.h"
#import "GroupViewController.h"
#import "UIColor+MHColors.h"

#import "GroupListManager.h"

@interface MissionsCollectionViewController () <GroupListManagerDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) GroupListManager *groupListManager;

@end

@implementation MissionsCollectionViewController

static NSString *const reuseIdentifier = @"GroupCell";

- (instancetype)initWithGroupListManager:(GroupListManager *)groupListManager {
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self = [self initWithCollectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[MissionsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.title = @"Missions";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup)];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self action:@selector(updateUserGroups) forControlEvents:UIControlEventValueChanged];
    
    self.collectionView.refreshControl = refreshControl;
    
    [self.collectionView addSubview:refreshControl];
    [self.collectionView setAlwaysBounceVertical:true];
    
    self.groupListManager = groupListManager;
    self.groupListManager.delegate = self;
    
    [self updateUserGroups];
    
    return self;
}

- (void)updateUserGroups {
    [self.groupListManager updateUserGroups];
}

- (void)addGroup {
    AddGroupViewController *addGroupViewController = [[AddGroupViewController alloc] initWithGroupListManager:self.groupListManager];
    UINavigationController *addGroupNavigationController = [[UINavigationController alloc] initWithRootViewController:addGroupViewController];
    
    [self presentViewController:addGroupNavigationController animated:true completion:nil];
}

#pragma mark <GroupManagerDelegate>

- (void)groupListManagerDidFinishUpdatingGroups:(GroupListManager *)groupListManager {
    if ([self.collectionView.refreshControl isRefreshing]) {
        [self.collectionView.refreshControl endRefreshing];
    }
    
    [self.collectionView reloadData];
}

- (void)groupListManagerDidFinishUpdateWithNoChanges:(GroupListManager *)groupListManager {
    if ([self.collectionView.refreshControl isRefreshing]) {
        [self.collectionView.refreshControl endRefreshing];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groupListManager.groups.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MissionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    MHGroup *group = self.groupListManager.groups[indexPath.row];
    
    cell.missionsLabel.text = group.name;
    cell.missionsLabel.textColor = [UIColor whiteColor];
    
    cell.backgroundColor = [UIColor flatColors][indexPath.row % [UIColor flatColors].count];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHGroup *group = self.groupListManager.groups[indexPath.row];
    
    GroupViewController *groupViewController = [[GroupViewController alloc] initWithGroupListManager:_groupListManager group:group];
    
    [self.navigationController pushViewController:groupViewController animated:true];
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect container = self.view.frame;
    float cellWidth = container.size.width / 2.0 - 15;
    
    return CGSizeMake(cellWidth, cellWidth);
}

@end
