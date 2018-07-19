//
//  TrailView.h
//  centerD
//
//  Created by 李希昂 on 2018/7/13.
//  Copyright © 2018年 李希昂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "CenterDViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
struct coordinate{
    double angle;
    double radius;
};
typedef struct coordinate coordinate;@interface TrailView : UIView
@property (strong,nonatomic) CBCharacteristic *characteristic;
@property (strong,nonatomic) NSMutableArray *locations;
@property coordinate preLoc;
@property coordinate presentLoc;
@property (strong,nonatomic) UIScrollView *scrollView;
-(void)reloadData;//刷新界面
-(void)updateLocation:(coordinate) l;//更新位置信息
-(void)resetLocation;//清屏

@end



