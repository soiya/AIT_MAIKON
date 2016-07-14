import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
PFont myFont;

// vibration Motor pin
final int VIBRATION_PIN = 14; 

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
int now_h = 0;
int now_m = 0;

// task state
int task_minutes = -1;
int task_hours = -1;

//flagment
boolean vibration_flag = false;

void setup(){
  size(200,200);
  arduino=new Arduino(this,"/dev/cu.usbserial-14P50261");
  
  //vibration motor  setup
  arduino.pinMode(VIBRATION_PIN,Arduino.OUTPUT);
  
  // button setup
  // Caution: INPUT_PULLUP (http://mag.switch-science.com/2013/05/23/input_pullup/)
  arduino.pinMode(BUTTON1_PIN,Arduino.INPUT);
  arduino.pinMode(BUTTON2_PIN,Arduino.INPUT);
  arduino.pinMode(BUTTON3_PIN,Arduino.INPUT);
  
  // 7segument setup
  for(int i=0; i < SEGU_KETA.length; i++){
    arduino.pinMode(SEGU_KETA[i],Arduino.OUTPUT);
  }
  
  // franerate setup
  frameRate(120);
}

void draw(){
  buttonRead();
  clock();
}


void clock(){
  now_h = hour();
  now_m = minute();
//  println("now time "+h+":"+m);
  showMatrix(now_h,now_m);
}

void buttonRead(){
  // button behavior
  if(arduino.digitalRead(BUTTON1_PIN) == Arduino.HIGH){
    button1State++;
    println("button1State = "+button1State);
  }
  else if(arduino.digitalRead(BUTTON2_PIN) == Arduino.HIGH){
    button2State++;
    println("button2State = "+button2State);
  }
  else if(arduino.digitalRead(BUTTON3_PIN) == Arduino.HIGH){
    //later
  }
  
  // 7segment display reset
  // hours
  if(button1State == 13){
    button1State = 0;
  }
  // minute
  if(button2State == 60){
    button1State = 0;
  }
}

void vivrationRead(){
  clock();
  if(task_hours == now_h && task_minutes == now_m){
    arduino.digitalWrite(VIBRATION_PIN, Arduino.HIGH);
    vibration_flag = true;
  }
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
