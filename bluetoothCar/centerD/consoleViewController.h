//
//  consoleViewController.h
//  centerD
//
//  Created by 李希昂 on 2018/7/17.
//  Copyright © 2018年 李希昂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterDViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "TrailView.h"
@interface consoleViewController : UIViewController
@property (strong,nonatomic) CBCharacteristic *characteristic;
@property (strong,nonatomic) NSMutableArray *peripherials;
@property (strong,nonatomic) CBCentralManager *manager;
@property (strong,nonatomic) CBPeripheral *peripherial;
@property (strong,nonatomic) CBCharacteristic *characterisic;
@property (nonatomic) BOOL isConnected;
@property (strong,nonatomic) TrailView *trailView;
@property (strong,nonatomic) NSMutableArray *tapArray;
@property (strong,nonatomic) UIViewController *fatherViewController;
@property int tag;
@end
