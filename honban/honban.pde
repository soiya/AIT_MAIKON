import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
PFont myFont;

final int SEGU_PIN  = 2;

final int SEGU_KETA[] = {7,9,10,13};
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

void setup(){
  size(200,200);
  arduino=new Arduino(this,"/dev/cu.usbserial-14P50261");
  
  arduino.pinMode(SEGU_PIN,Arduino.OUTPUT);
  for(int i=0; i < SEGU_KETA.length; i++){
    arduino.pinMode(SEGU_KETA[i],Arduino.OUTPUT);
  }
  frameRate(30);
}

void draw(){

  showMatrix();
}

void showMatrix(){
  for(int keta = 0; keta < 4; keta++){
    arduino.digitalWrite(SEGU_KETA[keta], Arduino.HIGH);
    for(int i = 0; i < USE_PIN.length; i++){
      arduino.digitalWrite(USE_PIN[i], INT_MATRIX[0][i]);
      arduino.digitalWrite(4, Arduino.HIGH);
    }
    delay(6);
  }
}

void button_read(){
  if(arduino.digitalRead(button_pin) == 1){
    n++;
    delay(200);
  }
  if(n == 10){
    n = 0;
  }
}
