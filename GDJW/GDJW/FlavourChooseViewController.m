//
//  FlavourChooseViewController.m
//  GDJW
//
//  Created by 李希昂 on 2017/7/4.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import "FlavourChooseViewController.h"
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)
@interface FlavourChooseViewController ()
@property NSInteger buttonTag;
@property(strong,nonatomic) UIButton *button1;
@property(strong,nonatomic) UIButton *button2;
@property(strong,nonatomic) UIButton *button3;
@property(strong,nonatomic) UIButton *button4;
@property(strong,nonatomic) UIButton *button5;
@property(strong,nonatomic) UIButton *button6;
@property(strong,nonatomic) UIButton *button7;
@property(strong,nonatomic) NSArray *buttons;
@end

@implementation FlavourChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景1"]]];self.button1 = [[UIButton alloc]init];
    self.button2 = [[UIButton alloc]init];
    self.button3 = [[UIButton alloc]init];
    self.button4 = [[UIButton alloc]init];
    self.button5 = [[UIButton alloc]init];
    self.button6 = [[UIButton alloc]init];
    self.button7 = [[UIButton alloc]init];
    self.buttons = @[self.button1,self.button2,self.button3,self.button4,self.button5,self.button6,self.button7];
    for (NSInteger i = 1; i < 8; i++) {
        UIButton *button = self.buttons[i-1];
        button.tag = i;
    }
    [self setButtonFrame];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) importTag:(NSInteger) tag{
    self.buttonTag = tag;
}

- (void) setNav:(UINavigationController*)nav {
    _nav = nav;
}

- (void) setButtonFrame{

    if (self.buttonTag == 1) {
        for(NSInteger i = 0; i<4 ;i++){
            UIButton *button = self.buttons[i];
            button.frame = CGRectMake(SCREEN_WIDTH/8, SCREEN_HEIGHT*(i+1)/6, SCREEN_WIDTH/3, SCREEN_HEIGHT/10);
            UIColor *color1= [UIColor colorWithPatternImage:[UIImage imageNamed:@"鸡块"]];
            [button setBackgroundColor:color1];
            button.layer.cornerRadius = 5;
            [self.view addSubview:button];
        }
        }
        for(NSInteger i = 4 ; i < 7 ;i++){
            UIButton *button = self.buttons[i];
            button.frame = CGRectMake(SCREEN_WIDTH*5/8, SCREEN_HEIGHT*(i-3)/6, SCREEN_WIDTH/3, SCREEN_HEIGHT/10);
            UIColor *color1= [UIColor colorWithPatternImage:[UIImage imageNamed:@"鸡块"]];
            [button setBackgroundColor:color1];
             button.layer.cornerRadius = 5;
            [self.view addSubview:button];
            
        }
        
    if (self.buttonTag == 2) {
        for(NSInteger i = 0; i<3 ;i++){
            UIButton *button = self.buttons[i];
            button.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT*(i+1)/6, SCREEN_WIDTH/3, SCREEN_HEIGHT/10);
            UIColor *color1= [UIColor colorWithPatternImage:[UIImage imageNamed:@"河粉"]];
            [button setBackgroundColor:color1];
            button.layer.cornerRadius = 5;
            [self.view addSubview:button];
            
        }
        for(NSInteger i = 4 ; i < 7 ;i++){
        UIButton *button = self.buttons[i];
            [button removeFromSuperview];
        }
    }
        if (self.buttonTag == 3) {
            for(NSInteger i = 0; i<3 ;i++){
                UIButton *button = self.buttons[i];
                button.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT*(i+1)/6, SCREEN_WIDTH/3, SCREEN_HEIGHT/10);
                UIColor *color1= [UIColor colorWithPatternImage:[UIImage imageNamed:@"意面"]];
                [button setBackgroundColor:color1];
                button.layer.cornerRadius = 5;
                [self.view addSubview:button];
            }
            for(NSInteger i = 4 ; i < 7 ;i++){
                UIButton *button = self.buttons[i];
                [button removeFromSuperview];
            }

            }
    
            if (self.buttonTag == 4) {
                for(NSInteger i = 0; i<3 ;i++){
                    UIButton *button = self.buttons[i];
                    button.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT*(i+1)/6, SCREEN_WIDTH/3, SCREEN_HEIGHT/10);
                    UIColor *color1= [UIColor colorWithPatternImage:[UIImage imageNamed:@"粉丝"]];
                    [button setBackgroundColor:color1];
                    button.layer.cornerRadius = 5;
                    [self.view addSubview:button];
                    
            }
                for(NSInteger i = 4 ; i < 7 ;i++){
                    UIButton *button = self.buttons[i];
                    [button removeFromSuperview];
                }

            }



    
    
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
