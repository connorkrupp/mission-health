//
//  GroupViewController.m
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "GroupViewController.h"

#import "GroupInfoViewController.h"
#import "GroupManager.h"
#import "GroupListManager.h"
#import "GroupMessageTableViewCell.h"

static NSString *const reuseIdentifier = @"MessageCell";

@interface GroupViewController () <GroupManagerDelegate>

@property (strong, nonatomic) MHGroup *group;
@property (strong, nonatomic) GroupListManager *groupListManager;
@property (strong, nonatomic) GroupManager *groupManager;
@end

@implementation GroupViewController

- (instancetype)initWithGroupListManager:(GroupListManager *)groupListManager group:(MHGroup *)group {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.group = group;
        self.groupListManager = groupListManager;
        self.groupManager = [groupListManager getGroupManagerForGroup:group];
        self.groupManager.delegate = self;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(composeMessage)];
        
        [self.tableView registerClass:[GroupMessageTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    
    return self;
}

- (void)viewDidLoad {
    [self refreshMessages];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    self.title = _group.name;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshMessages) forControlEvents:UIControlEventValueChanged];
    
    [super viewDidLoad];
}

- (void)refreshMessages {
    [self.groupManager reloadGroupMessages];
}

- (void)composeMessage {
    //AddGroupViewController *addGroupViewController = [[AddGroupViewController alloc] initWithGroupListManager:self.groupListManager];
    //UINavigationController *addGroupNavigationController = [[UINavigationController alloc] initWithRootViewController:addGroupViewController];
    
    //[self presentViewController:addGroupNavigationController animated:true completion:nil];
    [self.groupManager composeMessageWithBody:@"This is a test message"];
}

- (void)groupManagerDidLoadMessagesWithNoChanges:(GroupManager *)groupManager {
    [self.refreshControl endRefreshing];
}
- (void)groupManagerDidLoadMessages:(GroupManager *)groupManager {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)loadGroupInfo {
    GroupInfoViewController *groupInfoViewController = [[GroupInfoViewController alloc] initWithGroup:self.group];
    
    [self.navigationController pushViewController:groupInfoViewController animated:true];
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_group.messages.count > 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        return 1;
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No messages yet!";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"HKGrotesk" size:20];
        
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _group.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupMessageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    MHMessage *message = _group.messages[indexPath.row];
    
    cell.senderLabel.text = @"Konnor Krupp";
    cell.timestampLabel.text = @"6h ago";
    cell.bodyLabel.text = message.body;
    
    return cell;
}

@end
