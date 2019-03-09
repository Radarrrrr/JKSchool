//
//  AppDelegate.m
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MsgViewController.h"
#import "HealthViewController.h"
#import "MineViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //创建框架
    //Home树
    HomeViewController *homeVC  = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.navigationBarHidden = NO;
    homeNav.navigationBar.translucent = NO; //不要导航条模糊，为了让页面从导航条下部是0开始，如果为YES，则从屏幕顶部开始是0
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"学校" image:[UIImage imageNamed:@"bar_icon_home"] selectedImage:[UIImage imageNamed:@"bar_icon_home_sel"]];
    
    //消息树
    MsgViewController *msgVC  = [[MsgViewController alloc] init];
    UINavigationController *msgNav = [[UINavigationController alloc] initWithRootViewController:msgVC];
    msgNav.navigationBarHidden = NO;
    msgNav.navigationBar.translucent = NO; //不要导航条模糊，为了让页面从导航条下部是0开始，如果为YES，则从屏幕顶部开始是0
    msgNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"bar_icon_msg"] selectedImage:[UIImage imageNamed:@"bar_icon_msg_sel"]];
    msgNav.tabBarItem.badgeValue = @"2";
    msgNav.tabBarItem.badgeColor = [UIColor redColor];
    
    //健康树
    HealthViewController *healthVC  = [[HealthViewController alloc] init];
    UINavigationController *healthNav = [[UINavigationController alloc] initWithRootViewController:healthVC];
    healthNav.navigationBarHidden = NO;
    healthNav.navigationBar.translucent = NO; //不要导航条模糊，为了让页面从导航条下部是0开始，如果为YES，则从屏幕顶部开始是0
    healthNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"健康" image:[UIImage imageNamed:@"bar_icon_health"] selectedImage:[UIImage imageNamed:@"bar_icon_health_sel"]];

    //我的树
    MineViewController *mineVC  = [[MineViewController alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.navigationBarHidden = NO;
    mineNav.navigationBar.translucent = NO; //不要导航条模糊，为了让页面从导航条下部是0开始，如果为YES，则从屏幕顶部开始是0
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"bar_icon_mine"] selectedImage:[UIImage imageNamed:@"bar_icon_mine_sel"]];

    
    UITabBarController *mainTabBar = [[UITabBarController alloc] init];
    mainTabBar.view.backgroundColor = [UIColor whiteColor];
    mainTabBar.tabBar.backgroundColor = [UIColor whiteColor];
    mainTabBar.tabBar.backgroundImage = [[UIImage alloc] init];
    
    [mainTabBar setViewControllers:[NSArray arrayWithObjects:
                                    homeNav,
                                    msgNav,
                                    healthNav,
                                    mineNav,
                                    nil]];
    
    self.window.rootViewController = mainTabBar;
    
    
    
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
