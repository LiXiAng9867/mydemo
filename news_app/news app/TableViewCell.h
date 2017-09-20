//
//  TableViewCell.h
//  news app
//
//  Created by 李希昂 on 2017/5/22.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newsFrame.h"
#import "newsData.h"
#import "AppDelegate.h"
@interface TableViewCell : UITableViewCell
@property(nonatomic) UIImageView* img;
@property(nonatomic) UILabel* title;
@property(nonatomic) UILabel* time;
@property(nonatomic) CGFloat urlFrame;
@property(strong,nonatomic) newsFrame* dataFrame;
@property (strong,nonatomic) NSMutableDictionary *imgDict;
@property (strong,nonatomic) NSMutableDictionary *operations;
@property(strong,nonatomic) NSOperationQueue *queue;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

