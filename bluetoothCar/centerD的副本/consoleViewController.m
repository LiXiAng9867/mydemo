//
//  consoleViewController.m
//  centerD
//
//  Created by 李希昂 on 2018/7/17.
//  Copyright © 2018年 李希昂. All rights reserved.
//
#define kUUID @"AE6EBD76-4CF6-3B22-99E1-069B9CCD8A7C"
#define kServiceUUID @"FFE0"
#define kCharacteristicWriteUUID @"FFE1"
#import "consoleViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface consoleViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@end

@implementation consoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.tag == 2) {
        self.trailView = [[TrailView alloc]initWithFrame:CGRectMake(375/4, 150, 405/2, 667/3)];
        [self.view addSubview:self.trailView];
        self.tapArray = [[NSMutableArray alloc]init];
//        UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
//        imageView.image=[UIImage imageNamed:@"timg-7"];
//        [self.view insertSubview:imageView atIndex:0];
    }
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


- (IBAction)sendM1:(id)sender {
 
}

- (IBAction)sendM2:(id)sender {
   
}

- (IBAction)sendM3:(id)sender {//红外
    Byte byte[] = {};
    NSData *data = [[NSData alloc] initWithBytes:byte length:1];
    NSLog(@"send message ");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
}

- (IBAction)sendM4:(id)sender {//灭火
    Byte byte[] = {};
    NSData *data = [[NSData alloc] initWithBytes:byte length:1];
    NSLog(@"send message ");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
}

- (IBAction)sendM5:(id)sender {//跟踪
    Byte byte[] = {};
    NSData *data = [[NSData alloc] initWithBytes:byte length:1];
    NSLog(@"send message ");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
}

- (IBAction)clearTrailView:(id)sender {      //清屏
    [self.trailView removeFromSuperview];
    self.trailView = [[TrailView alloc]initWithFrame:CGRectMake(375/4, 150, 405/2, 667/3)];
    [self.view addSubview:self.trailView];
    [self.trailView resetLocation];
}


- (IBAction)sendTrail:(id)sender {  //路径
    Byte byte[] = {};
    NSData *data = [[NSData alloc] initWithBytes:byte length:1];
    NSLog(@"send message ");
    [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"avoiding"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        consoleViewController *avoiding = segue.destinationViewController;
        avoiding.tag = 2;
    }
    if ([segue.identifier isEqualToString:@"controller"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        consoleViewController *controller = segue.destinationViewController;
        controller.tag = 1;
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];//视图中的所有对象
    if ([touch locationInView:self.view].x>375/4&&[touch locationInView:self.view].x<375/4+405/2&&[touch locationInView:self.view].y>150&&[touch locationInView:self.view].y<150+667/3) {
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
        double x = point.x - 405/4;
        double y = (point.y - 667/6);
        coordinate l;
        l.angle = atan(y/x);
        if (x<0) {
            l.angle += 3.14159;
        }
        l.radius = sqrt(x*x+y*y);
        NSLog(@"touch (x, y) is (%f, %f, %f, %f)", x, y,l.angle*180/3.1415,l.radius);
        NSValue *customValue = [NSValue valueWithBytes:&l objCType:@encode(struct coordinate)];
        [self.tapArray addObject:customValue];
        [self.trailView updateLocation:l];
    }
}

- (IBAction)sendControllMessage:(UIButton*)sender {
    
    switch (sender.tag) {
        case 9://左转
        {Byte byte[] = {};
            NSData *data = [[NSData alloc] initWithBytes:byte length:4];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
            
            break;
        case 1://右转
        {Byte byte[] = {};
            NSData *data = [[NSData alloc] initWithBytes:byte length:4];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
            break;
        case 2://前进
        {Byte byte[] = {};
            NSData *data = [[NSData alloc] initWithBytes:byte length:4];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
            break;
        case 3://左移
        {Byte byte[] = {};
            NSData *data = [[NSData alloc] initWithBytes:byte length:4];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
            break;
        case 4://停止
        {Byte byte[] = {};
            NSData *data = [[NSData alloc] initWithBytes:byte length:4];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
            break;
        case 5://右移
        {Byte byte[] = {};
            NSData *data = [[NSData alloc] initWithBytes:byte length:4];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
            break;
        case 6://后退
        {Byte byte[] = {};
            NSData *data = [[NSData alloc] initWithBytes:byte length:4];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
            break;
        case 7://加速
        {Byte byte[] = {};
            NSData *data = [[NSData alloc] initWithBytes:byte length:4];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
            break;
        case 8://减速
        {Byte byte[] = {};
            NSData *data = [[NSData alloc] initWithBytes:byte length:4];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
            break;
            
        default:
            break;
    }
    
    
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
