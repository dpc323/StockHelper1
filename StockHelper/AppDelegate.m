//
//  AppDelegate.m
//  StockHelper
//
//  Created by dpc on 17/2/14.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SearchStockViewController.h"
#import "LoginViewController.h"
#import "StockInfo.h"
#import "PredictMarketViewController.h"
#import "LCTabBarController.h"
#import "WeekStockViewController.h"
#import "MonthViewController.h"
#import "DBUtils.h"

#import "HighLowDao.h"
#import "DatePredictInfo.h"
#import "DatePredictDao.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    //[self initUsers];
    // Override point for customization after application launch.

//    NSString *url = [NSString stringWithFormat:@"%@?s=%@",rootURL,@""];
//    [[DPCHTTPRequest shareInstance] getAddByUrlPath:url addParams:nil completion:^(id successBlock) {
//        NSDictionary *dic = successBlock;
//        if (dic) {
//            NSString *result = [[dic allValues] lastObject];
//            NSArray *resultArr = [result componentsSeparatedByString:@"\n"];
//          
//            NSString *stockStr = [resultArr objectAtIndex:1];
//            NSArray *stock = [stockStr componentsSeparatedByString:@","];
//            if(stock.count > 4)
//            {
//                NSString *lastTradeDate = [stock objectAtIndex:0];
//                [[NSUserDefaults standardUserDefaults] setObject:lastTradeDate forKey:@"lastTradeDate"];
//            }
//        }
//    } failedError:^(NSString *failBlock) {
//        
//    }];

    [DBUtils sharedDBManage];
    [self initTheMainTablebar];
    
    return YES;
}
-(void)initTheMainTablebar
{

    PredictMarketViewController *marketVC = [[PredictMarketViewController alloc] init];
    marketVC.title = @"大盘";
    //    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]) {
    SearchStockViewController *searchVC = [[SearchStockViewController alloc] initWithNibName:@"SearchStockViewController" bundle:nil];
    searchVC.title = @"日线";
    WeekStockViewController *weekVC = [[WeekStockViewController alloc] initWithNibName:@"WeekStockViewController" bundle:nil];
    weekVC.title = @"周线";
    MonthViewController *monthVC = [[MonthViewController alloc] initWithNibName:@"MonthViewController" bundle:nil];
    monthVC.title = @"月线";
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:marketVC];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:searchVC];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:weekVC];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:monthVC];

    LCTabBarController *tabBarC    = [[LCTabBarController alloc] init];

    tabBarC.itemTitleFont          = [UIFont boldSystemFontOfSize:11.0f];
    tabBarC.itemTitleColor         = [UIColor grayColor];
    tabBarC.selectedItemTitleColor = [UIColor blackColor];
    tabBarC.itemImageRatio         = 0.5f;
    tabBarC.badgeTitleFont         = [UIFont boldSystemFontOfSize:12.0f];
    
    tabBarC.viewControllers        = @[navC1, navC2,navC3,navC4];
    tabBarC.selectedIndex = 1;
    self.window.rootViewController = tabBarC;
    //    }else{
    //
    //        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    //        self.window.rootViewController = nav;
    //
    //    }
}

-(void)initUsers
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/user.plist"];
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < 10; i++) {
        NSString *userName = [NSString stringWithFormat:@"user%d",i];
        NSString *password = [NSString stringWithFormat:@"%d%d%d%d%d%d",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10];
        [userDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:password forKey:userName]];
    }
    [userDic writeToFile:path atomically:NO];
    NSLog(@"文件路径:%@",path);
    
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
