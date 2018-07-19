//
//  CenterDViewController.m
//  centerD
//
//  Created by 李希昂 on 2017/9/6.
//  Copyright © 2017年 李希昂. All rights reserved.
//
#import "consoleViewController.h"
#import <UIKit/UIKit.h>
#import "CenterDViewController.h"
#import "TrailView.h"
#import <CoreBluetooth/CoreBluetooth.h>
#define kUUID @"AE6EBD76-4CF6-3B22-99E1-069B9CCD8A7C"
#define kServiceUUID @"FFE0"
#define kCharacteristicWriteUUID @"FFE1"
@interface CenterDViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (strong,nonatomic) NSMutableArray *peripherials;
@property (strong,nonatomic) CBCentralManager *manager;
@property (strong,nonatomic) CBPeripheral *peripherial;
@property (strong,nonatomic) CBCharacteristic *characterisic;
@property (nonatomic) BOOL isConnected;
@property (strong,nonatomic) NSMutableArray *buttons;
@property (strong,nonatomic) NSMutableArray *states;
@property (strong,nonatomic) TrailView *trailView;
@end

@implementation CenterDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
//    imageView.image=[UIImage imageNamed:@"timg-7"];
//    [self.view insertSubview:imageView atIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCenterManagerAndPeripherials{
    if(!self.manager){
    self.manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    self.peripherials = [[NSMutableArray alloc]init];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBManagerStatePoweredOn) {
        [self.manager scanForPeripheralsWithServices:nil options:nil];
    }
   }

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
//    if(error){
//        NSLog(@"something goes wrong with the bluetooth connection");
//        [self writeToLog:@"something goes wrong with the bluetooth connection"];
//    }
//    [self writeToLog:[NSString stringWithFormat: @"%@",peripheral.description]];
    [self.peripherials addObject:peripheral];
    NSLog(@"connect to %@",peripheral.description);
    if([peripheral.identifier.UUIDString isEqualToString:kUUID]){
        [self.manager stopScan];
        [self.manager connectPeripheral:peripheral options:nil];
        NSLog(@"connect to %@",peripheral.description);
//         [self writeToLog:[NSString stringWithFormat: @"connect to %@",peripheral.description]];
        self.peripherial = peripheral;
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"connect to %@ success",peripheral.description);
//     [self writeToLog:[NSString stringWithFormat:@"connect to %@ success",peripheral.description]];
    [central stopScan];
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"连接%@失败",peripheral);
//     [self writeToLog:[NSString stringWithFormat:@"连接%@失败",peripheral]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for(CBService *service in peripheral.services){
        NSLog(@"%@",service.UUID.UUIDString);
        if([(NSString*)service.UUID.UUIDString isEqualToString:kServiceUUID]){
        NSLog(@"discover %@",service.UUID);
         //    [self writeToLog:[NSString stringWithFormat:@"discover %@",service.UUID]];
           [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
            
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"搜索特征%@时发生错误:%@", service.UUID, [error localizedDescription]);
    //     [self writeToLog:[NSString stringWithFormat:@"搜索特征%@时发生错误:%@", service.UUID, [error localizedDescription]]];
        return;
    }
    NSLog(@"服务:%@",service.UUID);
 //    [self writeToLog:[NSString stringWithFormat:@"服务:%@",service.UUID]];
    for (CBCharacteristic *characteristic in service.characteristics) {
        //        NSLog(@"特征:%@",characteristic);
        //发现特征
        NSLog(@"%@",characteristic.UUID.UUIDString);
        if ([characteristic.UUID.UUIDString isEqual:kCharacteristicWriteUUID]) {
            self.characterisic = characteristic;
        }
        if ([characteristic.UUID.UUIDString isEqual:kCharacteristicWriteUUID]) {
            NSLog(@"监听特征:%@",characteristic);//监听特征
    //       [self writeToLog:[NSString stringWithFormat:@"监听特征:%@",characteristic]];
            [self.peripherial setNotifyValue:YES forCharacteristic:characteristic];
            _isConnected = YES;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"更新特征值%@时发生错误:%@", characteristic.UUID, [error localizedDescription]);
  //       [self writeToLog:[NSString stringWithFormat:@"更新特征值%@时发生错误:%@", characteristic.UUID, [error localizedDescription]]];
        return;
    }
    
        NSLog(@"%@",[self hexadecimalString:characteristic.value]);
  //   [self writeToLog:[NSString stringWithFormat:@"%@",[self hexadecimalString:characteristic.value]]];
}

//将传入的NSData类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data{
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}
//将传入的NSString类型转换成NSData并返回
- (NSData*)dataWithHexstring:(NSString *)hexstring{
    NSData *aData;
    return aData = [hexstring dataUsingEncoding: NSASCIIStringEncoding];
}

- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type{
}


- (IBAction)init:(id)sender {
    [self initCenterManagerAndPeripherials];
    NSLog(@"init");
}


- (IBAction)goAction:(id)sender
{
    // 根据指定线的ID跳转到目标Vc
//    [self performSegueWithIdentifier:@"console" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"console"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        consoleViewController *console = segue.destinationViewController;
        console.characterisic = self.characterisic;
        console.peripherial = self.peripherial;
        console.tag = 0;
        // 这里不需要指定跳转了，因为在按扭的事件里已经有跳转的代码
        //        [self.navigationController pushViewController:receive animated:YES];
        
        NSString *str = [[NSString alloc]init];
        for (int i=99; i<100; i++) {
            NSLog(@" if (x == %D) {x1 = 0x%d;}\n",i,i) ;
            str = [str stringByAppendingString:[NSString stringWithFormat:@" if (y == %d) {byte[0] = 0x%d;}",i,i ]];
            
        }
        NSLog(str);
    }
}


@end
