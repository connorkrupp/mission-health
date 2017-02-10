//
//  AppDelegate.m
//  Mission Health
//
//  Created by Connor Krupp on 1/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "AppDelegate.h"
#import "PersistenceManager.h"
#import "Store.h"
#import "MHUser+CoreDataClass.h"
#import "DailySummaryViewController.h"
#import "MealManager.h"

@interface AppDelegate ()

@property (nonatomic, strong) Store *store;
@property (nonatomic, strong) PersistenceManager *persistenceManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.persistenceManager = [[PersistenceManager alloc] initWithStoreURL:self.storeURL modelURL:self.modelURL];
    self.store = [[Store alloc] init];
    
    self.store.managedObjectContext = self.persistenceManager.managedObjectContext;
    
    MealManager *mealManager = [[MealManager alloc] initWithManagedObjectContext:self.store.managedObjectContext];
    
    DailySummaryViewController *dailySummaryViewController = [[DailySummaryViewController alloc] initWithMealManager:mealManager];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dailySummaryViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (NSURL *)storeURL {
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL *)modelURL {
    return [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self.store.managedObjectContext save:NULL];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
