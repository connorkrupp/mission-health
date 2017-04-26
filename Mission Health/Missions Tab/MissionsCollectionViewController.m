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

#import "GroupManager.h"

@interface MissionsCollectionViewController () <GroupManagerDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) GroupManager *groupManager;

@end

@implementation MissionsCollectionViewController

static NSString * const reuseIdentifier = @"GroupCell";

- (instancetype)init {
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self = [self initWithCollectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[MissionsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.title = @"Missions";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup)];
    
    self.groupManager = [[GroupManager alloc] init];
    self.groupManager.delegate = self;
    [self.groupManager getGroups];
    
    return self;
}

- (void)addGroup {
    AddGroupViewController *addGroupViewController = [[AddGroupViewController alloc] initWithGroupManager:self.groupManager];
    UINavigationController *addGroupNavigationController = [[UINavigationController alloc] initWithRootViewController:addGroupViewController];
    
    [self presentViewController:addGroupNavigationController animated:true completion:nil];
}

#pragma mark <GroupManagerDelegate>

- (void)groupManagerDidLoadGroups:(GroupManager *)groupManager {
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groupManager.groups.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MissionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    MHGroup *group = self.groupManager.groups[indexPath.row];
    
    cell.missionsLabel.text = group.name;
    cell.missionsLabel.textColor = [UIColor whiteColor];
    NSArray<UIColor *> *colors = @[
                                   [UIColor colorWithRed:188.0/255.0 green:227.0/255.0 blue:166.0/255.0 alpha:1.0],
                                   [UIColor colorWithRed:242.0/255.0 green:187.0/255.0 blue:155.0/255.0 alpha:1.0],
                                   [UIColor colorWithRed:123.0/255.0 green:216.0/255.0 blue:237.0/255.0 alpha:1.0]
                                  ];
    
    cell.backgroundColor = colors[indexPath.row % colors.count];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MHGroup *group = self.groupManager.groups[indexPath.row];
    
    GroupViewController *groupViewController = [[GroupViewController alloc] initWithGroup:group];
    
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
