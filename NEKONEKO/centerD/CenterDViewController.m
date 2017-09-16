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
@property (strong, nonatomic) IBOutlet UIView *NekoView;
@property (strong,nonatomic) NSMutableArray *buttons;
@property (strong,nonatomic) NSMutableArray *states;
@property int pattern;
@end

@implementation CenterDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image=[UIImage imageNamed:@"123"];
    [self.view insertSubview:imageView atIndex:0];
    self.buttons = [[NSMutableArray alloc]init];
    self.states = [[NSMutableArray alloc]init];
    int i = 0;
    int c = 0 ;
    for(i = 0; i < 9; i++){
        int b = i % 3;
        self.buttons[i] = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * (1+b)/5+10, self.view.bounds.size.height * (6 + c)/10, 50, 50)];
        [(UIButton*)self.buttons[i] setBackgroundImage:[UIImage imageNamed:@"button_1"] forState:UIControlStateNormal];
        UIButton *button = self.buttons[i];
        button.tag = i;
        self.states[i] = @"0";
        [self.view addSubview:self.buttons[i]];
        if (b == 2){
            c++;
        }
        [(UIButton*)self.buttons[i] addTarget:self action:@selector(selectButtons:) forControlEvents:UIControlEventTouchUpInside ];
    }
    UIButton *GoButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * 2/5+10, self.view.bounds.size.height * 9/10, 50, 50)];
    [GoButton setBackgroundImage:[UIImage imageNamed:@"button_1"] forState:UIControlStateNormal];
    [GoButton addTarget:self action:@selector(goAndClear:) forControlEvents:UIControlEventTouchUpInside];
    [GoButton setTitle:@"GO" forState:UIControlStateNormal];
    [self.view addSubview:GoButton];
   // self.NekoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image1.png"]];
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
- (IBAction)sendLeftM:(id)sender {
    NSData *data = [@"4" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];

}
- (IBAction)sendRightM:(id)sender {
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

- (void)selectButtons:(UIButton*)sender{
    int state = 0;
    if([self.states[sender.tag] isEqualToString: @"0"]){
        state = 0;
    }
    if([self.states[sender.tag] isEqualToString: @"1"]){
        state = 1;
    }
    switch (state) {
        case 0:
            [self.states replaceObjectAtIndex:sender.tag withObject:@"1"];
            [sender setBackgroundImage:[UIImage imageNamed:@"button_2"] forState:UIControlStateNormal];
            break;
        case 1:
            [self.states replaceObjectAtIndex:sender.tag withObject:@"0"];
            [sender setBackgroundImage:[UIImage imageNamed:@"button_1"] forState:UIControlStateNormal];
        default:
            break;
    }
}

- (void)goAndClear:(id)sender{
    if (self.isConnected) {
       
    [self testPath];
    switch (self.pattern) {
        case 1:
            [self sendForwardM];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:1.0f];
            [self performSelector:@selector(sendLeftM) withObject:nil afterDelay:2.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:3.0f];
            [self performSelector:@selector(sendForwardM) withObject:nil afterDelay:4.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:5.0f];
            NSLog(@"1");
            break;
            
        case 2:
            [self sendForwardM];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:1.0f];
            [self performSelector:@selector(sendRightM) withObject:nil afterDelay:2.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:3.0f];
            [self performSelector:@selector(sendForwardM) withObject:nil afterDelay:4.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:5.0f];

            NSLog(@"2");
            break;
            
        case 3:
            [self sendForwardM];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:1.0f];
            [self performSelector:@selector(sendLeftM) withObject:nil afterDelay:2.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:3.0f];
            [self performSelector:@selector(sendForwardM) withObject:nil afterDelay:4.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:5.0f];
            [self performSelector:@selector(sendRightM) withObject:nil afterDelay:6.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:7.0f];
            [self performSelector:@selector(sendForwardM) withObject:nil afterDelay:8.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:9.0f];
            NSLog(@"4");

            NSLog(@"3");
            break;
            
        case 4:
            [self sendForwardM];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:1.0f];
            [self performSelector:@selector(sendRightM) withObject:nil afterDelay:2.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:3.0f];
            [self performSelector:@selector(sendForwardM) withObject:nil afterDelay:4.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:5.0f];
            [self performSelector:@selector(sendLeftM) withObject:nil afterDelay:6.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:7.0f];
            [self performSelector:@selector(sendForwardM) withObject:nil afterDelay:8.0f];
            [self performSelector:@selector(sendStopM) withObject:nil afterDelay:9.0f];            break;
            
        default:
            break;
    }
    int i = 0;
    for(i = 0; i < 9 ;i++){
        self.states[i] = @"0";
        [self.buttons[i] setBackgroundImage:[UIImage imageNamed:@"button_1"] forState:UIControlStateNormal];

    }
    }
}


- (void)testPath{
    if ([self.states[0] isEqualToString:@"1"]) {
        self.pattern = 1;
    }
    if ([self.states[8] isEqualToString:@"1"]){
        self.pattern = 2;
    }
    if ([self.states[4] isEqualToString:@"1"]&&[self.states[3] isEqualToString:@"1"]){
        self.pattern = 3;
    }
    if ([self.states[4] isEqualToString:@"1"]&&[self.states[7] isEqualToString:@"1"]){
        self.pattern = 4;
    }
}

- (void)sendStopM {
    NSData *data = [@"0" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message stop");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];
    
}
- (void)sendForwardM {
    NSData *data = [@"1" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message up");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];
    
}
- (void)sendBackM {
    NSData *data = [@"2" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message back");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];
    
}
- (void)sendLeftM {
    NSData *data = [@"4" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message left");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithResponse];
    
}
- (void)sendRightM {
    NSData *data = [@"3" dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"send message right");
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
