//
//  SizeViewController.m
//  GDJW
//
//  Created by 李希昂 on 2017/7/3.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import "SizeViewController.h"
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)
@interface SizeViewController ()
@property NSInteger buttonTag;
@property (strong,nonatomic) UINavigationController *nav;
@end

@implementation SizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bigSizeButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3,SCREEN_HEIGHT/4 , SCREEN_WIDTH/3, SCREEN_HEIGHT/10)];
    self.smallSizeButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3,SCREEN_HEIGHT/2 , SCREEN_WIDTH/3, SCREEN_HEIGHT/10)];
    [self.bigSizeButton setTitle:@"大号" forState:UIControlStateNormal];
    [self.smallSizeButton setTitle:@"小号" forState:UIControlStateNormal];
    self.bigSizeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];//[UIFont systemFontOfSize:30];
    self.smallSizeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];// [UIFont systemFontOfSize:30];
    self.bigSizeButton.layer.cornerRadius = 10;
    self.smallSizeButton.layer.cornerRadius = 10;
    [self.bigSizeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.smallSizeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景1"]]];
    switch (self.buttonTag) {
        case 1:
            self.bigSizeButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"鸡块"]];
            self.smallSizeButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"鸡块"]];
            break;
        
        case 2:
            self.bigSizeButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"河粉"]];
            self.smallSizeButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"河粉"]];
            break;

        case 3:
            self.bigSizeButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"意面"]];
            self.smallSizeButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"意面"]];
            break;

        case 4:
            self.bigSizeButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"粉丝"]];
            self.smallSizeButton.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"粉丝"]];
            break;

        default:
            break;
    }
    [self.view addSubview:self.bigSizeButton];
    [self.view addSubview:self.smallSizeButton];
   
    [self.bigSizeButton addTarget:self action:@selector(TurnToFlavoueChooseView) forControlEvents:UIControlEventTouchUpInside];
    [self.smallSizeButton addTarget:self action:@selector(TurnToFlavoueChooseView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@""
                                                                style:UIBarButtonItemStylePlain
                                                               target:nil
                                                               action:nil];
    self.navigationController.navigationBar.tintColor =
    [UIColor colorWithRed:0.99 green:0.50 blue:0.09 alpha:1.00];
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"商店-4"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"商店-4"];
    self.navigationItem.backBarButtonItem = backItem;
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) importTag:(NSInteger) tag{
    self.buttonTag = tag;
}

- (void) TurnToFlavoueChooseView {
    FlavourChooseViewController *flavourChooseViewController = [[FlavourChooseViewController alloc]init];
    [flavourChooseViewController importTag:self.buttonTag];
    [flavourChooseViewController setNav:self.nav];
    [self.nav pushViewController:flavourChooseViewController animated:YES];
}

- (void) setNav:(UINavigationController*)nav {
    _nav = nav;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
