//
//  AppDelegate.m
//  news app
//
//  Created by 李希昂 on 2017/5/21.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDB.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.navController = [[UINavigationController alloc]init];
    ViewController *rootView = [[ViewController alloc]init];
//    [self internetDownload:rootView];
    [self.navController pushViewController:rootView animated:YES];
    self.navController.navigationBar.translucent = YES;
    self.window.rootViewController = self.navController;
    [self.window addSubview:self.navController.view];
    self.navController.navigationBar.barTintColor =[UIColor colorWithRed:157.0/255 green:15.0/255 blue:5.0/255 alpha:1];
    self.navController.navigationBar.tintColor = [UIColor whiteColor];
    rootView.title = @"MyNews";
    [self.window makeKeyAndVisible];
    self.imgDict = [[NSMutableDictionary alloc]init];
    self.queue = [[NSOperationQueue alloc]init];
    self.operations = [[NSMutableDictionary alloc]init];
    self.buttonTextArray = [[NSMutableArray alloc]init];
    [self.navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"timg.jepg"] forBarMetrics:UIBarMetricsDefault];
//    self.buttonArray = [[NSMutableArray alloc]init];
    
//    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"text.plist" ofType:nil];
//    self.buttonTextArray= [NSMutableArray arrayWithContentsOfFile:fullPath];
//    [self.buttonTextArray removeObject:@""];
    
//    NSURL *defaultPrefsFile = [[NSBundle mainBundle]
//                               URLForResource:@"DefaultPreferences" withExtension:@"plist"];
//    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
//    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"text"];
    self.buttonTextArray = [NSMutableArray arrayWithArray:array];
    //NSString*appDomain = [[NSBundlemainBundle]bundleIdentifier];
    
    [fmdbTool count];
    
    
    
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

//-(void)internetDownload:(ViewController*)tableview{
//    NSString *urlString = [NSString stringWithFormat:@"http://wangyi.butterfly.mopaasapp.com/news/api?type=%@&page=%@&limit=10",tableview.presentContent,tableview.page];
//    NSURL *url = [ NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (data && !error) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//            //   [self.war addObjectsFromArray:[dict objectForKey:@"list"]];
//            NSLog(@"%@",dict);
//            
//            
//            NSMutableArray *arrays = [dict objectForKey:@"list"];
//            
//            for(NSMutableDictionary *dictionary in arrays)
//            {
//                newsData *data = [[newsData alloc] initWithDict:dictionary];
//                //                for (NSDictionary *status in statuses) {
//                // NSDictionary --> NSData
//                //                    NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:status];
//                //                    [_db executeUpdateWithFormat:@"INSERT INTO t_status(status, idstr) VALUES (%@, %@);", statusData, status[@"idstr"]];
//                //                }  将数据存入数据库
//                newsFrame *dataFrame = [[newsFrame alloc]init];
//                dataFrame.newsData = data;
//                [tableview.war addObject:dataFrame];//data[@"channelname"] isequalto ?? [self.?? addobject ]
//            }
//            [tableview.tableview reloadData];
//            
//        }
//        
//    }] resume];
//    tableview.totalArray = tableview.war;
//    [tableview.tableview reloadData];
//}


@end
