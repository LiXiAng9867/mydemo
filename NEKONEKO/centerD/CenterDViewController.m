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
#define kUUID @"AE0F0D1E-4FBD-4547-BDEA-35D47DB7DA33"
#define kServiceUUID @"FFE0"
#define kCharacteristicWriteUUID @"FFE1"
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
    if([peripheral.identifier.UUIDString isEqualToString:kUUID]){
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
        NSLog(@"%@",service.UUID.UUIDString);
        if([(NSString*)service.UUID.UUIDString isEqualToString:kServiceUUID]){
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
        NSLog(@"%@",characteristic.UUID.UUIDString);
        if ([characteristic.UUID.UUIDString isEqual:kCharacteristicWriteUUID]) {
            self.characterisic = characteristic;
        }
        if ([characteristic.UUID.UUIDString isEqual:kCharacteristicWriteUUID]) {
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

- (IBAction)init:(id)sender {
    [self initCenterManagerAndPeripherials];
}

-(void)writeToLog:(NSString *)info{
    self.log.text=[NSString stringWithFormat:@"%@\r\n%@",self.log.text,info];
}

- (IBAction)sendStopM:(id)sender {
    NSData *data = [@"0" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];

}
- (IBAction)sendForwardM:(id)sender {
    NSData *data = [@"1" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];

}
- (IBAction)sendBackM:(id)sender {
    NSData *data = [@"2" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];

}
- (IBAction)sendRightM:(id)sender {
    NSData *data = [@"4" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];

}
- (IBAction)sendLeftM:(id)sender {
    NSData *data = [@"3" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];
}
- (IBAction)sendVoiceM:(id)sender {
    NSData *data = [@"6" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];
}

- (IBAction)sendFeedM:(id)sender {
    NSData *data = [@"8" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];
}

- (IBAction)sendRotateM:(id)sender {
    NSData *data = [@"9" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];
}

- (IBAction)sendLightM:(id)sender {
    NSData *data = [@"7" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];
}

- (IBAction)sendAutoM:(id)sender {
    NSData *data = [@"5" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];
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
