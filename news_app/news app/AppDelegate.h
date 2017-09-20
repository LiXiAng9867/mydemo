//
//  AppDelegate.h
//  news app
//
//  Created by 李希昂 on 2017/5/21.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UINavigationController *navController;
@property (strong,nonatomic) NSMutableDictionary *imgDict;
@property (strong,nonatomic) NSMutableDictionary *operations;
@property(strong,nonatomic) NSOperationQueue *queue;
@property(strong,nonatomic) NSMutableArray *buttonArray;
@property(strong,nonatomic) NSMutableArray *buttonTextArray;
@end

