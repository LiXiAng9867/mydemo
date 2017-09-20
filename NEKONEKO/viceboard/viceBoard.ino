#include <Servo.h> 
Servo myservo;  //创建一个舵机控制对象
Servo servo;                         // 使用Servo类最多可以控制8个舵机
int pos = 0;    // 该变量用与存储舵机角度位置
int lightPin = 8;
int tail = 10;
int light = 11;
int music = 12;
int pinBuzzer = 7; //管脚D3连接到蜂鸣器模块的信号脚  
bool lightOn = 0;
bool tailOn = 0;
bool feedOn = 0;//缺舵机 弄不弄再说
bool musicOn = 0;

void setup() {
  Serial.begin(9600);
  myservo.attach(9);  // 该舵机由arduino第九脚控制
  servo.attach(6);
  pinMode(pinBuzzer, OUTPUT); //设置pinBuzzer脚为输出状态 
  pinMode(lightPin,OUTPUT);
}

void loop() {
  
   if(digitalRead(light) == HIGH){
    lightOn = 1;
   }
   if(digitalRead(light) == LOW){
    lightOn = 0;
   }
   if(digitalRead(tail) == HIGH){
    tailOn = 1;
   }
   if(digitalRead(tail) == LOW){
    tailOn = 0;
   }
  if(digitalRead(music) == HIGH){
    musicOn = 1;
   }
   if(digitalRead(music) == LOW){
    musicOn = 0;
   }
  if(tailOn){
      for(pos = 0; pos < 90; pos += 1)  // 从0度到180度运动 
    {                                                     // 每次步进一度
    myservo.write(pos);        // 指定舵机转向的角度
    delay(15);                       // 等待15ms让舵机到达指定位置
    } 
     for(pos =90; pos>=1; pos-=1)   //从180度到0度运动  
    {                                
    myservo.write(pos);         // 指定舵机转向的角度 
    delay(15);                        // 等待15ms让舵机到达指定位置 
    } 
  }
  if(lightOn){
    digitalWrite(lightPin,HIGH);for(pos = 0; pos < 180; pos += 1)  // 从0度到180度运动 
    {                                                     // 每次步进一度
    servo.write(pos);        // 指定舵机转向的角度
    delay(15);                       // 等待15ms让舵机到达指定位置
    } 
     for(pos =180; pos>=1; pos-=1)   //从180度到0度运动  
    {                                
    servo.write(pos);         // 指定舵机转向的角度 
    delay(15);                        // 等待15ms让舵机到达指定位置 
    } 
  }
  if(!lightOn){
    digitalWrite(lightPin,LOW);
  }
  if(musicOn){
    long frequency = 300; //频率, 单位Hz  
   //用tone()函数发出频率为frequency的波形  
   tone(pinBuzzer, frequency );  
   delay(1000); //等待1000毫秒  
   noTone(pinBuzzer);//停止发声   
  }
}
