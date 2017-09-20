//
//  changeViewController.h
//  news app
//
//  Created by 李希昂 on 2017/5/24.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "fmdbTool.h"
@interface changeViewController : UIViewController
@property (strong,nonatomic) UIButton *war;
@property (strong,nonatomic) UIButton *gupiao;
@property (strong,nonatomic) UIButton *lady;
@property (strong,nonatomic) UIButton *ent;
@property (strong,nonatomic) UIButton *edu;
@property (strong,nonatomic) UIButton *travel;
@property (strong,nonatomic) UIButton *sport;
@property (strong,nonatomic) UIButton *tech;
@property (strong,nonatomic) UIButton *money;
@property (strong,nonatomic) UIButton *deleteDB;
@property (nonatomic) NSInteger count;
@end
