//
//  TabBarController.m
//  GDJW
//
//  Created by 李希昂 on 2017/7/3.
//  Copyright © 2017年 李希昂. All rights reserved.
//
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)
#import "TabBarController.h"
#import "ChooseViewController.h"
#import "OrderViewController.h"
#import "ShoppingCaryViewController.h"
@interface TabBarController ()<UITabBarControllerDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    ChooseViewController *chooseViewController = [[ChooseViewController alloc]init];
    OrderViewController *orderViewController = [[OrderViewController alloc]init];
    ShoppingCaryViewController *shoppingCartViewController = [[ShoppingCaryViewController alloc]init];
    UINavigationController *chooseViewNavController = [[UINavigationController alloc]initWithRootViewController:chooseViewController];
    chooseViewController.navigationItem.title = @"古德鸡王";
    [chooseViewNavController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,nil]];
    chooseViewNavController.navigationBar.barTintColor = [UIColor blackColor];
//    [chooseViewNavController.navigationBar setTranslucent:NO];
    [chooseViewController setNav:chooseViewNavController];
    self.viewControllers = @[chooseViewNavController,orderViewController,shoppingCartViewController];
    
    UITabBarItem *choose = [[UITabBarItem alloc]initWithTitle:@"商店" image:[[UIImage imageNamed:@"商店-3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"商店-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *order = [[UITabBarItem alloc]initWithTitle:@"订单" image:[[UIImage imageNamed:@"订单-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"订单-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *shoppingCart = [[UITabBarItem alloc]initWithTitle:@"购物车" image:[[UIImage imageNamed:@"购物车"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"购物车-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    chooseViewController.tabBarItem = choose;
    orderViewController.tabBarItem = order;
    shoppingCartViewController.tabBarItem = shoppingCart;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary
                                                       dictionaryWithObjectsAndKeys:[UIColor colorWithRed:76/255.0f green:76/255.0f blue:76/255.0f alpha:1],
                                                       NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [self.tabBar setTintColor:[UIColor redColor]];
    [self.tabBar setBarTintColor:[UIColor blackColor]];
    
    self.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)tabBarController:(UITabBarController*)tabBarController           shouldSelectViewController:(UIViewController*)viewController {
    
    //    if([tabBarController.viewControllers indexOfObject:viewController] == 1) {
    //        return NO;
    //    }
    return YES;
}


@end
