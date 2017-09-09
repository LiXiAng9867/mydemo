//
//  CenterDViewController.m
//  centerD
//
//  Created by 李希昂 on 2017/9/6.
//  Copyright © 2017年 李希昂. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CenterDViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#define kServiceUUID @""
#define kCharacteristicWriteUUID@""
@interface CenterDViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (strong,nonatomic) NSMutableArray *peripherials;
@property (strong,nonatomic) CBCentralManager *manager;
@property (strong,nonatomic) CBPeripheral *peripherial;
@property (strong,nonatomic) CBCharacteristic *characterisic;
@property (nonatomic) BOOL isConnected;
@property (weak, nonatomic) IBOutlet UITextView *log;
@end

@implementation CenterDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self writeToLog:[NSString stringWithFormat: @"%@",peripheral.description]];
    [self.peripherials addObject:peripheral];
    NSLog(@"connect to %@",peripheral.description);
    if([peripheral.identifier.UUIDString isEqualToString:kServiceUUID]){
        [self.manager stopScan];
        [self.manager connectPeripheral:peripheral options:nil];
        NSLog(@"connect to %@",peripheral.description);
         [self writeToLog:[NSString stringWithFormat: @"connect to %@",peripheral.description]];
        self.peripherial = peripheral;
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"connect to %@ success",peripheral.description);
     [self writeToLog:[NSString stringWithFormat:@"connect to %@ success",peripheral.description]];
    [central stopScan];
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"连接%@失败",peripheral);
     [self writeToLog:[NSString stringWithFormat:@"连接%@失败",peripheral]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for(CBService *service in peripheral.services){
        if([(NSString*)service.UUID isEqualToString:kServiceUUID]){
        NSLog(@"discover %@",service.UUID);
             [self writeToLog:[NSString stringWithFormat:@"discover %@",service.UUID]];
           [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
            
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"搜索特征%@时发生错误:%@", service.UUID, [error localizedDescription]);
         [self writeToLog:[NSString stringWithFormat:@"搜索特征%@时发生错误:%@", service.UUID, [error localizedDescription]]];
        return;
    }
    NSLog(@"服务:%@",service.UUID);
     [self writeToLog:[NSString stringWithFormat:@"服务:%@",service.UUID]];
    for (CBCharacteristic *characteristic in service.characteristics) {
        //        NSLog(@"特征:%@",characteristic);
        //发现特征
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicWriteUUID]]) {
            self.characterisic = characteristic;
        }
        if ([characteristic.UUID isEqual:kCharacteristicWriteUUID]) {
            NSLog(@"监听特征:%@",characteristic);//监听特征
            [self writeToLog:[NSString stringWithFormat:@"监听特征:%@",characteristic]];
            [self.peripherial setNotifyValue:YES forCharacteristic:characteristic];
            _isConnected = YES;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"更新特征值%@时发生错误:%@", characteristic.UUID, [error localizedDescription]);
         [self writeToLog:[NSString stringWithFormat:@"更新特征值%@时发生错误:%@", characteristic.UUID, [error localizedDescription]]];
        return;
    }
    
        NSLog(@"%@",[self hexadecimalString:characteristic.value]);
     [self writeToLog:[NSString stringWithFormat:@"%@",[self hexadecimalString:characteristic.value]]];
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

- (IBAction)sendUpMessage:(id)sender {
    NSData *data = [@"up" dataUsingEncoding:NSUTF8StringEncoding];
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];
}

- (IBAction)init:(id)sender {
    [self initCenterManagerAndPeripherials];
}

-(void)writeToLog:(NSString *)info{
    self.log.text=[NSString stringWithFormat:@"%@\r\n%@",self.log.text,info];
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
