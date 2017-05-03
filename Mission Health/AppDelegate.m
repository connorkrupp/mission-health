//
//  AppDelegate.m
//  Mission Health
//
//  Created by Connor Krupp on 1/25/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+MHColors.h"
#import "AppCoordinator.h"

@interface AppDelegate ()

@property (strong, nonatomic) AppCoordinator *appCoordinator;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //og blue UIColor *primary = [UIColor colorWithRed:46.0/255.0 green:196.0/255.0 blue:182.0/255.0 alpha:1.0];
    //green UIColor *primary = [UIColor colorWithRed:36.0/255.0 green:219.0/255.0 blue:165.0/255.0 alpha:1.0];
    [UINavigationBar appearance].barTintColor = [UIColor primaryColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].translucent = false;
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:[UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"HKGrotesk-SemiBold" size:19.0]
                                                           }];
    
    [UITabBar appearance].tintColor = [UIColor primaryColor];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.appCoordinator = [[AppCoordinator alloc] initWithWindow:self.window];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
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
