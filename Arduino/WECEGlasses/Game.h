#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#include <Arduino.h>

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels

// Declaration for SSD1306 display connected using software SPI (default case):
#define OLED_RESET     4 // Reset pin 
#define SCREEN_ADDRESS 0x3C 

boolean playing = false;

class Game{

  public:
    Adafruit_SSD1306 oled = Adafruit_SSD1306(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
  
    void obsticales(int w, int h, int numRect){
      int obst[numRect][2];
      int XPOS = 0;
      int YPOS = 1;
      int DELTAX = 2; 
      int counter = 0;
      int space;
      playing = true;
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
      // drawing rectangles 
      while(playing == true){
        delay(100);
        oled.clearDisplay();
        //draw rectangles
        for(int f=0; f < numRect; f++) {
          if(obst[f][XPOS] <= oled.width()-1 && obst[f][XPOS] >= 0){
            oled.fillRect(obst[f][XPOS], obst[f][YPOS], w, h, WHITE);
            oled.display();
          } 
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
    
    // player movement
    void player(){
      
    }
}
