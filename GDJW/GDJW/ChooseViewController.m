//
//  ChooseViewController.m
//  GDJW
//
//  Created by 李希昂 on 2017/7/3.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import "ChooseViewController.h"
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

@interface ChooseViewController ()
@property(strong,nonatomic) UIButton *button1;
@property(strong,nonatomic) UIButton *button2;
@property(strong,nonatomic) UIButton *button3;
@property(strong,nonatomic) UIButton *button4;
@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景1"]]];
    NSInteger i = 1;
    self.button1 = [[UIButton alloc]init];
    self.button2 = [[UIButton alloc]init];
    self.button3 = [[UIButton alloc]init];
    self.button4 = [[UIButton alloc]init];
    
    UIColor *color1= [UIColor colorWithPatternImage:[UIImage imageNamed:@"鸡块"]];
    [self.button1 setTitle:@"鸡块" forState:UIControlStateNormal];
    UIColor *color2 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"河粉"]];
    [self.button2 setTitle:@"河粉" forState:UIControlStateNormal];
    UIColor *color3 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"意面"]];
    [self.button3 setTitle:@"意面" forState:UIControlStateNormal];
    UIColor *color4 = [UIColor colorWithPatternImage:[UIImage imageNamed:@"粉丝"]];
    [self.button4 setTitle:@"粉丝" forState:UIControlStateNormal];
   
    NSArray *buttons = @[self.button1,self.button2,self.button3,self.button4];
    NSArray *colors = @[color1,color2,color3,color4];
    
    for (i = 0; i < 4; i++) {
        UIButton *but = buttons[i];
        but.tag = i + 1;
    }
    
    [self.button1 addTarget:self action:@selector(changeToSubView:) forControlEvents:UIControlEventTouchUpInside];
    
    for(i =1;i<5;i++){
        UIButton *button = buttons[i-1];
        button.frame =  CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT*i/6, SCREEN_WIDTH/3, SCREEN_HEIGHT/10);
        button.layer.cornerRadius = 10;
        button.titleLabel.font = [UIFont systemFontOfSize:32];
        button.layer.masksToBounds = YES;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIView *backView = [[UIView alloc]initWithFrame:button.bounds];
        backView.userInteractionEnabled = NO;
        [backView setBackgroundColor:colors[i-1]];
        [button addSubview:backView];
        [button sendSubviewToBack:backView];
        backView.alpha = 0.7;
        [self.view addSubview:button];
        [buttons[i-1] addTarget:self action:@selector(changeToSubView:) forControlEvents:UIControlEventTouchUpInside];
}
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeToSubView:(id)sender {
    UIButton *tempButton = sender;
    if(tempButton.tag == 1){
    SizeViewController *sizeViewController = [[SizeViewController alloc]init];
    [sizeViewController setNav:self.nav];
    [sizeViewController importTag:tempButton.tag];
    [self.nav pushViewController:sizeViewController animated:YES];
    NSLog(@"跳转到大小选择界面");
    }
    else{
        UIButton *tempButton = sender;
        FlavourChooseViewController *flavourViewController = [[FlavourChooseViewController alloc]init];
        [flavourViewController setNav:self.nav];
        [flavourViewController importTag:tempButton.tag];
        [self.nav pushViewController:flavourViewController animated:YES];
        NSLog(@"跳转到口味选择界面");
        
    }
    
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
