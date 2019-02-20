//
//  AppDelegate.m
//  easyTravel
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "MainViewController.h"
#import "ShopViewController.h"
#import "LoginViewController.h"
#import "UserViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AppLogic.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "TestViewController.h"
#import "AddHotelOrderViewController.h"
//#import "AddHotelOrderViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "BasicNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:10 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [NSThread sleepForTimeInterval:0.1f];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    
    UINavigationController *firstNav = [[UINavigationController alloc] init];
    firstNav.navigationBar.hidden=YES;
    GuideViewController *guideViewController = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
    [firstNav pushViewController:guideViewController animated:NO];
    
    /**/
    MainViewController *mainViewController = [[MainViewController  alloc] initWithNibName:@"MainViewController" bundle:nil];
    BasicNavigationController *nav1 = [[BasicNavigationController alloc] initWithRootViewController:mainViewController];
//    nav1.navigationBar.translucent = YES;
//    [nav1 pushViewController:mainViewController animated:YES];
    
    ShopViewController * vc2 = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
//    [nav2 pushViewController:[[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil]animated:YES];
    
    UserViewController * vc3 = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
//    nav3.navigationBar.translucent = YES;
//    [nav3 pushViewController:[[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil]animated:YES];
    
    
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tab1.png"] selectedImage:[UIImage imageNamed:@"tab1.png"]];
    nav1.tabBarItem = item1;
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"客服" image:[UIImage imageNamed:@"tab2.png"] selectedImage:[UIImage imageNamed:@"tab2.png"]];
    nav2.tabBarItem = item2;
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[UIImage imageNamed:@"tab3.png"] selectedImage:[UIImage imageNamed:@"tab3.png"]];
    nav3.tabBarItem = item3;
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3,nil];
    
    /*
    MainViewController *mainViewController = [[MainViewController  alloc] initWithNibName:@"MainViewController" bundle:nil];
    ShopViewController *shopViewController = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    UserViewController *userViewController = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tab1.png"] selectedImage:[UIImage imageNamed:@"tab1.png"]];
    mainViewController.tabBarItem = item1;
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"商城" image:[UIImage imageNamed:@"tab2.png"] selectedImage:[UIImage imageNamed:@"tab2.png"]];
    shopViewController.tabBarItem = item2;
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[UIImage imageNamed:@"tab3.png"] selectedImage:[UIImage imageNamed:@"tab3.png"]];
    userViewController.tabBarItem = item3;
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.viewControllers = [NSArray arrayWithObjects:mainViewController,shopViewController,userViewController,nil];
    
    UINavigationController *nav = [[UINavigationController alloc] init];
    [nav pushViewController:tab animated:YES];*/
    
    
//    UINavigationController *nav = [[UINavigationController alloc] init];
//    TestViewController *addHotelOrderViewController = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
//    [nav pushViewController:addHotelOrderViewController animated:YES];
    
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"guideOver"]){
        self.window.rootViewController = tab;
    }else{
        self.window.rootViewController = firstNav;
    }
    //self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [WXApi registerApp:@"wxc2060c3a95dfd9c3" withDescription:@"易行商旅"];
    
    /*
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024 diskCapacity:40 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];*/
    
    
    [[AppLogic sharedInstance] initUserInfo];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    
    _xmlParser = [[XmlDataParser alloc] init];
    [_xmlParser StartParse:@"http://api.test.lohoo.com/xml/v2.0/hotel/geo_cn.xml" isWebXmlLink:true];
    
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    /**/
     //跳转支付宝钱包进行支付，处理支付结果
     [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
         
         NSLog(@"Appdelete__result = %@",resultDic);
         
    	}];
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}


@end
