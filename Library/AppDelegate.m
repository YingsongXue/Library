//
//  AppDelegate.m
//  Library
//
//  Created by 薛 迎松 on 14/11/2.
//  Copyright (c) 2014年 薛 迎松. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobeConfig.h"
#import "UIColor+MLPFlatColors.h"
#import "PAHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    PAHomeViewController *homeViewController = [[PAHomeViewController alloc] init];
    self.naviController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    self.window.rootViewController = self.naviController;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
//    [UINavigationBar appearance].backgroundColor = [UIColor blueColor];
//    [UINavigationBar appearance].tintColor = [UIColor blueColor];
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           [UIColor whiteColor],NSForegroundColorAttributeName,
                           [UIFont systemFontOfSize:22.0], NSFontAttributeName,
                           nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attrs];
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
    [[UISwitch appearance] setOnTintColor:[UIColor flatOrangeColor]]; //UIColorFromRGB(0x1672c1)
    [[UISearchBar appearance] setTintColor:UIColorFromRGB(0xD7D7D7)]; //[BC_Fmt getColorByRGBstr:@"#D7D7D7"]
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
