int Echo = A0;  
int Trig =A1;  

int Front_Distance = 0;
int Left_Distance = 0;
int Right_Distance = 0;

int Left_motor_back=5;     
int Left_motor_go=6;    

int Right_motor_go=9;    
int Right_motor_back=10;    
int tail = 2;
int light = 3;
int music = 4; 
int servopin=12;
int myangle;
int pulsewidth;
int val;
int outputPin = 11;
void setup()
{
  Serial.begin(9600);     
  pinMode(Left_motor_go,OUTPUT); // PIN 5 (PWM)
  pinMode(Left_motor_back,OUTPUT); // PIN 6 (PWM)
  pinMode(Right_motor_go,OUTPUT);// PIN 9 (PWM) 
  pinMode(Right_motor_back,OUTPUT);// PIN 10 (PWM)
  pinMode(light,OUTPUT);
  pinMode(music,OUTPUT);
  pinMode(tail,OUTPUT);
 
  pinMode(Echo, INPUT);    
  pinMode(servopin,OUTPUT);
}

 void run()     
{
  analogWrite(Right_motor_go,200);
  analogWrite(Right_motor_back,0);
  analogWrite(Left_motor_go,200);
  analogWrite(Left_motor_back,0);
}

void brake()         
{
  digitalWrite(Right_motor_go,LOW);
  digitalWrite(Right_motor_back,LOW);
  digitalWrite(Left_motor_go,LOW);
  digitalWrite(Left_motor_back,LOW);
}

void left()         
{
  analogWrite(Right_motor_go,200); 
  analogWrite(Right_motor_back,0);
  digitalWrite(Left_motor_go,LOW);   
  digitalWrite(Left_motor_back,LOW);
}

void spin_left()        
{
  analogWrite(Right_motor_go,200); 
  analogWrite(Right_motor_back,0);

  analogWrite(Left_motor_go,0); 
  analogWrite(Left_motor_back,200);
}

void right()        
{
  digitalWrite(Right_motor_go,LOW);   
  digitalWrite(Right_motor_back,LOW);

  analogWrite(Left_motor_go,200); 
  analogWrite(Left_motor_back,0);
  } 


void spin_right()
{
  analogWrite(Right_motor_go,0); 
  analogWrite(Right_motor_back,200);

  analogWrite(Left_motor_go,200); 
  analogWrite(Left_motor_back,0);
}

void back()          //后退
{
  analogWrite(Right_motor_go,0);
  analogWrite(Right_motor_back,150);

  analogWrite(Left_motor_go,0);
  analogWrite(Left_motor_back,150);
}


float Distance_test()    
{
  digitalWrite(Trig, LOW);   
  delayMicroseconds(2);
  digitalWrite(Trig, HIGH);  
  delayMicroseconds(10);
  digitalWrite(Trig, LOW);    
  float Fdistance = pulseIn(Echo, HIGH);  
  Fdistance= Fdistance/58;  
  return Fdistance;
}  



void servopulse(int servopin,int myangle)
{
  pulsewidth=(myangle*11)+500;
  digitalWrite(servopin,HIGH);
  delayMicroseconds(pulsewidth);
  digitalWrite(servopin,LOW);
  delay(20-pulsewidth/1000);
}

void front_detection()
{
  
  for(int i=0;i<=5;i++) 
  {
    servopulse(servopin,90);
  }
  Front_Distance = Distance_test();
  //Serial.print("Front_Distance:");      
 // Serial.println(Front_Distance);        
 //Distance_display(Front_Distance);
}

void left_detection()
{
  for(int i=0;i<=15;i++) 
  {
    servopulse(servopin,175);
  }
  Left_Distance = Distance_test();
 // Serial.print("Left_Distance:");     
 // Serial.println(Left_Distance);        
}

void right_detection()
{
  for(int i=0;i<=15;i++) 
  {
    servopulse(servopin,5);
  }
  Right_Distance = Distance_test();
 // Serial.print("Right_Distance:");      
 // Serial.println(Right_Distance);         
}

void loop()
{
 static bool voiceOn = 0;
 static bool lightOn = 0;
 static bool feedSwitchOn = 0;
 static bool rotateTailOn = 0;   
 static bool autoPattonOn = 0;
    if(Serial.available()>0){
      char ch = Serial.read();
      
      if(ch == '1'){
        run();
         //前进
         Serial.println("up");
      }else if(ch == '2'){
         //后退
         back();
         Serial.println("back");
      }else if(ch == '3'){
         //左转
         left();
         Serial.println("left");
      }else if(ch == '4'){
        //右转
        right();
         Serial.println("right");
      }else if(ch=='0'){
        //停车
        brake();
        Serial.println("stop");
      }else if(ch == '5'){
        autoPattonOn = !autoPattonOn;
        Serial.println(autoPattonOn);
      }else if(ch=='6'){
        voiceOn = !voiceOn;
        if(voiceOn){
          digitalWrite(music,HIGH);
        }
        if(!voiceOn){
         digitalWrite(music,LOW);
        }
        Serial.println("voice");
        Serial.println(voiceOn);
      }else if(ch=='7'){
        lightOn = !lightOn;
        if(lightOn){
          digitalWrite(light,HIGH);
        }
        if(!lightOn){
          digitalWrite(light,LOW);
        }
        
        Serial.println("light");
      }else if(ch=='8'){
        feedSwitchOn = !feedSwitchOn;
        Serial.println("feed");
      }else if(ch=='9'){
        if(rotateTailOn){
          digitalWrite(tail,HIGH);
        }
        if(!rotateTailOn){
          digitalWrite(tail,LOW);
        }
        rotateTailOn = !rotateTailOn;
        Serial.println("tail");
      }
    }
    if(autoPattonOn){
      front_detection();
      if(Front_Distance < 32)
     {
       back();
       delay(200);
       brake();
        left_detection();
        right_detection();
        if((Left_Distance < 35 ) &&( Right_Distance < 35 )){ 
            spin_left();
            delay(100);
         }
         else if(Left_Distance > Right_Distance)//左边比右边空旷
         {      
        left();//左转
        delay(300);
        brake();}
         else
         {
            right();
            delay(300);
            brake();
         }
      }
         else
         {
            run();      
         }
    }
   
}


