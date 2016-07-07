import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
PFont myFont;

// button pin
final int BUTTON1_PIN  = 15;
final int BUTTON2_PIN  = 16;
final int BUTTON3_PIN  = 17;

//7segment pin
final int SEGU_KETA[] = {13,10,9,7};
final int USE_PIN[] = {2,3,5,8,12,11,6};
final int INT_MATRIX[][] = {
  {0,0,0,0,0,0,1}, // 0
  {1,1,0,0,1,1,1}, // 1
  {0,0,1,0,0,1,0}, // 2
  {1,0,0,0,0,1,0}, // 3
  {1,1,0,0,1,0,0}, // 4
  {1,0,0,1,0,0,0}, // 5
  {0,0,0,1,0,0,0}, // 6
  {1,1,0,0,0,1,1}, // 7 
  {0,0,0,0,0,0,0}, // 8 
  {1,0,0,0,0,0,0}, // 9 
};

// button state
int button1State = 0;
int button2State = 0;
int button3State = 0;

// time state
int h = 0;
int m = 0;

void setup(){
  size(200,200);
  arduino=new Arduino(this,"/dev/cu.usbserial-14P50261");
  
  arduino.pinMode(BUTTON1_PIN,Arduino.INPUT);
  arduino.pinMode(BUTTON2_PIN,Arduino.INPUT);
  arduino.pinMode(BUTTON3_PIN,Arduino.INPUT);
  for(int i=0; i < SEGU_KETA.length; i++){
    arduino.pinMode(SEGU_KETA[i],Arduino.OUTPUT);
  }
  frameRate(30);
}

void draw(){
  clock();
}

void clock(){
  h = hour();
  m = minute();
  println("now time "+h+":"+m);
  showMatrix(h,m);
}



void showMatrix(int a, int b){
  arduino.digitalWrite(4, Arduino.HIGH);
  
  for(int keta = 0; keta < 4; keta++){
    if(keta == 0){
      for(int i = 0; i < USE_PIN.length; i++){arduino.digitalWrite(USE_PIN[i], INT_MATRIX[a/10][i]);}
      arduino.digitalWrite(SEGU_KETA[keta], Arduino.HIGH);
      delay(5);
      arduino.digitalWrite(SEGU_KETA[keta], Arduino.LOW);
    }
    else if(keta == 1){
      for(int i = 0; i < USE_PIN.length; i++){arduino.digitalWrite(USE_PIN[i], INT_MATRIX[a%10][i]);}
      arduino.digitalWrite(SEGU_KETA[keta], Arduino.HIGH);
      delay(5);
      arduino.digitalWrite(SEGU_KETA[keta], Arduino.LOW);
    }
    else if(keta == 2){
      for(int i = 0; i < USE_PIN.length; i++){arduino.digitalWrite(USE_PIN[i], INT_MATRIX[b/10][i]);}
      arduino.digitalWrite(SEGU_KETA[keta], Arduino.HIGH);
      delay(5);
      arduino.digitalWrite(SEGU_KETA[keta], Arduino.LOW);
    }
    else if(keta == 3){
      for(int i = 0; i < USE_PIN.length; i++){arduino.digitalWrite(USE_PIN[i], INT_MATRIX[b%10][i]);}
      arduino.digitalWrite(SEGU_KETA[keta], Arduino.HIGH);
      delay(5);
      arduino.digitalWrite(SEGU_KETA[keta], Arduino.LOW);
    }
  }
}

void button_read(){
  if(arduino.digitalRead(BUTTON1_PIN) == 1){
    button1State++;
  }
  if(arduino.digitalRead(BUTTON2_PIN) == 1){
    button2State++;
  }
  if(arduino.digitalRead(BUTTON3_PIN) == 1){
    //later
  }
  if(button1State == 13){
    button1State = 0;
  }
  if(button2State == 60){
    button1State = 0;
  }
}
