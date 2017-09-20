//
//  ViewController.h
//  news app
//
//  Created by 李希昂 on 2017/5/21.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newsData.h"
#import "newsFrame.h"
#import "TableViewCell.h"
#import "AppDelegate.h"
#import "changeViewController.h"
#import "Reachability.h"
//#import "FMDB.h"
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(strong,nonatomic) NSString* presentContent;
@property(strong,nonatomic) NSString* page;
@property(strong,nonatomic) NSMutableArray *war;
@property(strong,nonatomic) NSMutableArray *gupiao;
@property(strong,nonatomic) NSMutableArray *lady;
@property(strong,nonatomic) NSMutableArray *sport;
@property(strong,nonatomic) NSMutableArray *edu;
@property(strong,nonatomic) NSMutableArray *ent;
@property(strong,nonatomic) NSMutableArray *tech;
@property(strong,nonatomic) NSMutableArray *money;
@property(strong,nonatomic) NSMutableArray *travel;
@property(strong,nonatomic) NSMutableArray *totalArray;
@property (nonatomic , strong) UITableView *tableview;
@property (nonatomic,strong) UIView* tabelViewFooterView;
@property(nonatomic,strong) UILabel *pages;
@property(strong,nonatomic) NSMutableArray *dataArray;
@property BOOL internetState;
@end

