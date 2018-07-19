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
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property int count;
@end

@implementation consoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.tag == 2) {
        self.trailView = [[TrailView alloc]initWithFrame:CGRectMake(375/4, 150, 405/2, 667/3)];
        [self.view addSubview:self.trailView];
        self.tapArray = [[NSMutableArray alloc]init];
        self.count = 0;
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
        NSLog(@"%chagnge uuid string@",characteristic.UUID.UUIDString);
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
    
    NSLog(@"%@value change",[self hexadecimalString:characteristic.value]);
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
    int y = 21;
    NSString *str;
    if(y>9){
        str = [NSString stringWithFormat:@"0x%d",y];
    }
    if(y<10){
        str = [NSString stringWithFormat:@"0x0%d",y];
    }
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    //  unsigned long red = strtoul([str UTF8String],0,16);
    //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    unsigned long red = strtoul([str UTF8String],0,16);
    NSLog(@"%lx",red);
    Byte byte[1] ;
    byte[0] = red;
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
    [self.tapArray removeAllObjects];
    self.count = 0;
}


- (IBAction)sendTrail:(id)sender {  //路径
    coordinate temp ;
    [self.tapArray[self.count] getValue:&temp];
    int x = temp.radius*cos(temp.angle)/2;
    int y = temp.radius*sin(temp.angle)/2;
    NSLog(@"%d,%d",x,y);
    for (int count = 0; count<4; count++) {
        if (count == 0) {
        Byte byte[] = {0xfe};
        NSData *data = [[NSData alloc] initWithBytes:byte length:1];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
        if (count == 1) {
            Byte byte[] = {0xfc};
            NSData *data = [[NSData alloc] initWithBytes:byte length:1];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
        if (count == 2) {
            NSString *str;
            if(y>9){
            str = [NSString stringWithFormat:@"0x%d",y];
            }
            if(y<10){
            str = [NSString stringWithFormat:@"0x0%d",y];
            }
            //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
            //  unsigned long red = strtoul([str UTF8String],0,16);
            //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
            unsigned long red = strtoul([str UTF8String],0,16);
            NSLog(@"%lx",red);
            Byte byte[1] ;
            byte[0] = red;
            NSData *data = [[NSData alloc] initWithBytes:byte length:1];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
        if (count == 3) {
            Byte byte[1] ;
            if (y == 0) {byte[0] = 0x0;} if (y == 1) {byte[0] = 0x1;} if (y == 2) {byte[0] = 0x2;} if (y == 3) {byte[0] = 0x3;} if (y == 4) {byte[0] = 0x4;} if (y == 5) {byte[0] = 0x5;} if (y == 6) {byte[0] = 0x6;} if (y == 7) {byte[0] = 0x7;} if (y == 8) {byte[0] = 0x8;} if (y == 9) {byte[0] = 0x9;} if (y == 10) {byte[0] = 0x10;} if (y == 11) {byte[0] = 0x11;} if (y == 12) {byte[0] = 0x12;} if (y == 13) {byte[0] = 0x13;} if (y == 14) {byte[0] = 0x14;} if (y == 15) {byte[0] = 0x15;} if (y == 16) {byte[0] = 0x16;} if (y == 17) {byte[0] = 0x17;} if (y == 18) {byte[0] = 0x18;} if (y == 19) {byte[0] = 0x19;} if (y == 20) {byte[0] = 0x20;} if (y == 21) {byte[0] = 0x21;} if (y == 22) {byte[0] = 0x22;} if (y == 23) {byte[0] = 0x23;} if (y == 24) {byte[0] = 0x24;} if (y == 25) {byte[0] = 0x25;} if (y == 26) {byte[0] = 0x26;} if (y == 27) {byte[0] = 0x27;} if (y == 28) {byte[0] = 0x28;} if (y == 29) {byte[0] = 0x29;} if (y == 30) {byte[0] = 0x30;} if (y == 31) {byte[0] = 0x31;} if (y == 32) {byte[0] = 0x32;}if (y == 33) {byte[0] = 0x33;} if (y == 34) {byte[0] = 0x34;} if (y == 35) {byte[0] = 0x35;} if (y == 36) {byte[0] = 0x36;} if (y == 37) {byte[0] = 0x37;} if (y == 38) {byte[0] = 0x38;} if (y == 39) {byte[0] = 0x39;} if (y == 40) {byte[0] = 0x40;} if (y == 41) {byte[0] = 0x41;} if (y == 42) {byte[0] = 0x42;} if (y == 43) {byte[0] = 0x43;} if (y == 44) {byte[0] = 0x44;} if (y == 45) {byte[0] = 0x45;} if (y == 46) {byte[0] = 0x46;} if (y == 47) {byte[0] = 0x47;} if (y == 48) {byte[0] = 0x48;} if (y == 49) {byte[0] = 0x49;} if (y == 50) {byte[0] = 0x50;} if (y == 51) {byte[0] = 0x51;} if (y == 52) {byte[0] = 0x52;} if (y == 53) {byte[0] = 0x53;} if (y == 54) {byte[0] = 0x54;} if (y == 55) {byte[0] = 0x55;} if (y == 56) {byte[0] = 0x56;} if (y == 57) {byte[0] = 0x57;} if (y == 58) {byte[0] = 0x58;} if (y == 59) {byte[0] = 0x59;} if (y == 60) {byte[0] = 0x60;} if (y == 61) {byte[0] = 0x61;} if (y == 62) {byte[0] = 0x62;} if (y == 63) {byte[0] = 0x63;} if (y == 64) {byte[0] = 0x64;} if (y == 65) {byte[0] = 0x65;}if (y == 66) {byte[0] = 0x66;} if (y == 67) {byte[0] = 0x67;} if (y == 68) {byte[0] = 0x68;} if (y == 69) {byte[0] = 0x69;} if (y == 70) {byte[0] = 0x70;} if (y == 71) {byte[0] = 0x71;} if (y == 72) {byte[0] = 0x72;} if (y == 73) {byte[0] = 0x73;} if (y == 74) {byte[0] = 0x74;} if (y == 75) {byte[0] = 0x75;} if (y == 76) {byte[0] = 0x76;} if (y == 77) {byte[0] = 0x77;} if (y == 78) {byte[0] = 0x78;} if (y == 79) {byte[0] = 0x79;} if (y == 80) {byte[0] = 0x80;} if (y == 81) {byte[0] = 0x81;} if (y == 82) {byte[0] = 0x82;} if (y == 83) {byte[0] = 0x83;} if (y == 84) {byte[0] = 0x84;} if (y == 85) {byte[0] = 0x85;} if (y == 86) {byte[0] = 0x86;} if (y == 87) {byte[0] = 0x87;} if (y == 88) {byte[0] = 0x88;} if (y == 89) {byte[0] = 0x89;} if (y == 90) {byte[0] = 0x90;} if (y == 91) {byte[0] = 0x91;} if (y == 92) {byte[0] = 0x92;} if (y == 93) {byte[0] = 0x93;} if (y == 94) {byte[0] = 0x94;} if (y == 95) {byte[0] = 0x95;} if (y == 96) {byte[0] = 0x96;} if (y == 97) {byte[0] = 0x97;} if (y == 98) {byte[0] = 0x98;}if (y == 99) {byte[0] = 0x99;}
            NSData *data = [[NSData alloc] initWithBytes:byte length:1];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
        if (count == 4) {
            Byte byte[] = {0xfd};
            NSData *data = [[NSData alloc] initWithBytes:byte length:1];
            NSLog(@"send message ");
            [self.peripherial writeValue:data forCharacteristic:self.characterisic type:CBCharacteristicWriteWithoutResponse];
        }
        
    }
    
    
    self.count++;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"avoiding"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        consoleViewController *avoiding = segue.destinationViewController;
          avoiding.characterisic = self.characterisic;
         avoiding.peripherial = self.peripherial ;
        avoiding.tag = 2;
    }
    if ([segue.identifier isEqualToString:@"controller"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        consoleViewController *controller = segue.destinationViewController;
        controller.characterisic = self.characterisic ;
         controller.peripherial =self.peripherial  ;
        controller.tag = 1;
    }
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];//视图中的所有对象
    if ([touch locationInView:self.view].x>375/4&&[touch locationInView:self.view].x<375/4+405/2&&[touch locationInView:self.view].y>150&&[touch locationInView:self.view].y<150+667/3) {
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
        double x = point.x ;
        double y = -(point.y -667/3);
        coordinate l;
        l.angle = atan(y/x);
        if (x<0) {
            l.angle += 3.14159;
        }
        l.radius = sqrt(x*x+y*y);
        int x1 = x/2;
        int y1 = y/2;
        self.textView.text = [NSString stringWithFormat:@" (%d, %d)", x1, y1];
        NSLog(@"touch (x, y) is (%d, %d, %f, %f)", x, y,l.angle*180/3.1415,l.radius);
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
        {Byte byte[] = {0x01};
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
