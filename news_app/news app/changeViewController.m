//
//  changeViewController.m
//  news app
//
//  Created by 李希昂 on 2017/5/24.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import "changeViewController.h"

@interface changeViewController ()
@property(strong,nonatomic) NSMutableArray *buttonArray;
@property(strong,nonatomic) NSMutableArray *buttonTextArray;
@end

@implementation changeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *mydelegate = [[UIApplication sharedApplication]delegate];
    self.buttonArray = mydelegate.buttonArray;
    self.buttonTextArray = mydelegate.buttonTextArray;
    self.deleteDB = [[UIButton alloc]initWithFrame:CGRectMake(180, 490, 200, 50)];
    self.war = [[UIButton alloc]initWithFrame:CGRectMake(30, 370, 80, 50)];
    self.war.tag = 1;
    self.gupiao = [[UIButton alloc]initWithFrame:CGRectMake(80, 410, 80, 50)];
    self.gupiao.tag = 2;
    self.lady = [[UIButton alloc]initWithFrame:CGRectMake(130, 450, 80, 50)];
    self.lady.tag = 3;
    self.ent = [[UIButton alloc]initWithFrame:CGRectMake(180, 130, 80, 50)];
    self.ent.tag = 4;
    self.edu = [[UIButton alloc]initWithFrame:CGRectMake(230, 170, 80, 50)];
    self.edu.tag = 5;
    self.travel = [[UIButton alloc]initWithFrame:CGRectMake(180, 210, 80, 50)];
    self.travel.tag = 6;
    self.sport = [[UIButton alloc]initWithFrame:CGRectMake(130, 250, 80, 50)];
    self.sport.tag = 7;
    self.tech = [[UIButton alloc]initWithFrame:CGRectMake(80, 290, 80, 50)];
    self.tech.tag = 8;
    self.money = [[UIButton alloc]initWithFrame:CGRectMake(30, 330, 80, 50)];
    self.money.tag = 9;
    [self.deleteDB setTitle:@"清理缓存" forState:UIControlStateNormal];
    [self.war setTitle:@"军事" forState:UIControlStateNormal];
    [self.gupiao setTitle:@"股票" forState:UIControlStateNormal];
    [self.lady setTitle:@"女性" forState:UIControlStateNormal];
    [self.ent setTitle:@"娱乐" forState:UIControlStateNormal];
    [self.edu setTitle:@"教育" forState:UIControlStateNormal];
    [self.sport setTitle:@"体育" forState:UIControlStateNormal];
    [self.tech setTitle:@"技术" forState:UIControlStateNormal];
    [self.money setTitle:@"经济" forState:UIControlStateNormal];
    [self.travel setTitle:@"旅游" forState:UIControlStateNormal];
    [self.view addSubview:self.war];
    [self.view addSubview:self.gupiao];
    [self.view addSubview:self.lady];
    [self.view addSubview:self.ent];
    [self.view addSubview:self.edu];
    [self.view addSubview:self.travel];
    [self.view addSubview:self.sport];
    [self.view addSubview:self.tech];
    [self.view addSubview:self.money];
    [self.view addSubview:self.deleteDB];
    self.view.backgroundColor = [UIColor blackColor];
    [self.deleteDB addTarget:self action:@selector(deleteDBAction) forControlEvents:UIControlEventTouchUpInside];
    [self.war addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.gupiao addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lady addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.edu addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.ent addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tech addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.travel addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.money addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sport addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *bgImg1 = [UIImage imageNamed:@"label.png"];
    UIImage *bgImg2 = [UIImage imageNamed:@"label-2.png"];
    [self.deleteDB setBackgroundImage:bgImg1 forState:UIControlStateNormal];
    [self.war setBackgroundImage:bgImg1 forState:UIControlStateNormal];
    [self.war setBackgroundImage:bgImg2 forState:UIControlStateSelected];
    [self.gupiao setBackgroundImage:bgImg1 forState:UIControlStateNormal];
    [self.gupiao setBackgroundImage:bgImg2 forState:UIControlStateSelected];
    [self.ent setBackgroundImage:bgImg1 forState:UIControlStateNormal];
    [self.ent setBackgroundImage:bgImg2 forState:UIControlStateSelected];
    [self.edu setBackgroundImage:bgImg1 forState:UIControlStateNormal];
    [self.edu setBackgroundImage:bgImg2 forState:UIControlStateSelected];
    [self.tech setBackgroundImage:bgImg1 forState:UIControlStateNormal];
    [self.tech setBackgroundImage:bgImg2 forState:UIControlStateSelected];
    [self.travel setBackgroundImage:bgImg1 forState:UIControlStateNormal];
    [self.travel setBackgroundImage:bgImg2 forState:UIControlStateSelected];
    [self.lady setBackgroundImage:bgImg1 forState:UIControlStateNormal];
    [self.lady setBackgroundImage:bgImg2 forState:UIControlStateSelected];
    [self.money setBackgroundImage:bgImg1 forState:UIControlStateNormal];
    [self.money setBackgroundImage:bgImg2 forState:UIControlStateSelected];
    [self.sport setBackgroundImage:bgImg1 forState:UIControlStateNormal];
    [self.sport setBackgroundImage:bgImg2 forState:UIControlStateSelected];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;

    NSInteger i;
    for(i=0;i<self.buttonTextArray.count;i++){
        if([self.buttonTextArray[i] isEqualToString:@"军事"]){
            self.war.selected = YES;
        }
        if([self.buttonTextArray[i] isEqualToString:@"股票"]){
            self.gupiao.selected = YES;
        }
        if([self.buttonTextArray[i] isEqualToString:@"娱乐"]){
            self.ent.selected = YES;
        }
        if([self.buttonTextArray[i] isEqualToString:@"教育"]){
            self.edu.selected = YES;
        }
        if([self.buttonTextArray[i] isEqualToString:@"旅游"]){
            self.travel.selected = YES;
        }
        if([self.buttonTextArray[i] isEqualToString:@"女性"]){
            self.lady.selected = YES;
        }
        if([self.buttonTextArray[i] isEqualToString:@"经济"]){
            self.money.selected = YES;
        }
        if([self.buttonTextArray[i] isEqualToString:@"体育"]){
            self.sport.selected = YES;
        }
        if([self.buttonTextArray[i] isEqualToString:@"科技"]){
            self.tech.selected = YES;
        }

    }
    
}


-(void) buttonAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
        if(button.selected == NO&&self.buttonTextArray.count <= 5){
        switch (button.tag) {
            case 1:
                [self.buttonTextArray removeObject:@"军事"];
                break;
            case 2:
                [self.buttonTextArray removeObject:@"股票"];
                break;
            case 3:
                [self.buttonTextArray removeObject:@"女性"];
                break;
            case 4:
                [self.buttonTextArray removeObject:@"娱乐"];
                break;
            case 5:
                [self.buttonTextArray removeObject:@"教育"];
                break;
            case 6:
                [self.buttonTextArray removeObject:@"旅游"];
                break;
            case 7:
                [self.buttonTextArray removeObject:@"体育"];
                break;
            case 8:
                [self.buttonTextArray removeObject:@"科技"];
                break;
            case 9:
                [self.buttonTextArray removeObject:@"经济"];
                break;
                
            default:
                break;
        }
    }

    else if (self.buttonTextArray.count == 5&&button.selected == YES){
        button.selected = !button.selected;
    }
    if(button.selected == YES&&self.buttonTextArray.count <= 4){
        switch (button.tag) {
            case 1:
                [self.buttonTextArray addObject:@"军事"];
                break;
            case 2:
                [self.buttonTextArray addObject:@"股票"];
                break;
            case 3:
                [self.buttonTextArray addObject:@"女性"];
                break;
            case 4:
                [self.buttonTextArray addObject:@"娱乐"];
                break;
            case 5:
                [self.buttonTextArray addObject:@"教育"];
                break;
            case 6:
                [self.buttonTextArray addObject:@"旅游"];
                break;
            case 7:
                [self.buttonTextArray addObject:@"体育"];
                break;
            case 8:
                [self.buttonTextArray addObject:@"科技"];
                break;
            case 9:
                [self.buttonTextArray addObject:@"经济"];
                break;
                
            default:
                break;
        }
    }
    NSLog(@"%@",self.buttonTextArray);
}

-(void)deleteDBAction{
    [fmdbTool deleteDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectRightAction:(id)sender
{
    int i = 0,j=4;
    for(i = 0;i < self.buttonTextArray.count;i++){
        [(UIButton*)self.buttonArray[i] setTitle:self.buttonTextArray[i] forState:UIControlStateNormal];
        [self.buttonArray[i] setUserInteractionEnabled:YES];

    }

    for(j=4;j>=i;j--){
         [(UIButton*)self.buttonArray[j] setTitle:@"" forState:UIControlStateNormal];
        [self.buttonArray[j] setUserInteractionEnabled:NO];
    }
//    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"text.plist" ofType:nil];
//    [self.buttonTextArray writeToFile:fullPath atomically:YES];
//    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:fullPath];
//    NSLog(@"%@1234",array);
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.buttonTextArray forKey:@"text"];
    [defaults synchronize];
    AppDelegate *mydelegate = [[UIApplication sharedApplication]delegate];
    mydelegate.buttonTextArray = self.buttonTextArray;
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
