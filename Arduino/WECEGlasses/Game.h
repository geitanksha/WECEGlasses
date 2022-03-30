#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#include <Arduino.h>
#include "ButtonHandler.h"


#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels

// Declaration for SSD1306 display connected using software SPI (default case):
#define OLED_RESET     4 // Reset pin 
#define SCREEN_ADDRESS 0x3C 
Adafruit_SSD1306 oled = Adafruit_SSD1306(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
boolean playing = false;
int XPOS = 0;
int YPOS = 1;
int maxJ = 1;
int minJ = 0;

ButtonHandler  button;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
  oled.begin(SSD1306_SWITCHCAPVCC);

  oled.clearDisplay();
  delay(2000); // Pause for 2 seconds
  game(10,5,10);
}

// put your main code here, to run repeatedly:
  
  
void loop(){
    
}


void game(int w, int h, int numRect){
  int obst[numRect][2];
  int DELTAX = 2; 
  int t = 0;
  int space;
  int ply[2][2];
  ply[minJ][XPOS] = 10;
  ply[minJ][YPOS] = oled.height()-10;
  ply[maxJ][XPOS] = 10;
  ply[maxJ][YPOS] = oled.height()-20;
  playing = true;
  
  //initialize obstacle and player location
  for(int f=0; f < numRect; f++){
    space = random(30,60);
    if (f==0){
      obst[f][XPOS] = oled.width()-1;
    }
    else{
      obst[f][XPOS]   = obst[f-1][XPOS] + (w+space);
    } 
    obst[f][YPOS]   = oled.height() - 6;
   }
   
 
  while(playing == true){
    delay(100);
    oled.clearDisplay();
    
    //draw rectangles
    for(int f=0; f < numRect; f++) {
      if(obst[f][XPOS] <= oled.width()-1 && obst[f][XPOS] >= 0){
        oled.fillRect(obst[f][XPOS], obst[f][YPOS], w, h, WHITE);
        //player jumps
        if(button.readState() == 1 || t>0){
          oled.drawRect(ply[maxJ][XPOS],ply[maxJ][YPOS], 10,10, WHITE);
          t++;
        }
        if(t==0){
          oled.drawRect(ply[minJ][XPOS],ply[minJ][YPOS], 10,10, WHITE);
        }
        oled.display();
      } 
    }
    // counter keeps player in "air" long enough to clear width of obstacle
    if(t > 3.5*numRect){
      t=0;
    }

    //update rectangle location
    for(int f=0; f < numRect; f++) {
          obst[f][XPOS] -= DELTAX;
          space = random(30,60);
          // If rectangle is off the bottom of the screen...
          if (obst[f][XPOS] < 0) {
            if(f == 0){
              if(obst[numRect-1][XPOS] > oled.width()-5){
                obst[f][XPOS]   = obst[numRect-1][XPOS] + w + space;
              }
              else{
                obst[f][XPOS]   = oled.width();           
              }
            }
            else {
             if(obst[f-1][XPOS] > oled.width()-5){
                obst[f][XPOS]   = obst[f-1][XPOS] + w + space;
              }
              else{
                obst[f][XPOS]   = oled.width();           
              }
            }
          }
            // Reinitialize to a random position, just off the right
  
     }

  }
}
