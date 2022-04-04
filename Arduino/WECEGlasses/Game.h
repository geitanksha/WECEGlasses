#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#include <Arduino.h>
#include "ButtonHandler.h"
#include "DisplayHandler.h"

class Game {
  private:
    boolean playing = false;
    int XPOS = 0;
    int YPOS = 1;
    int maxJ = 1;
    int minJ = 0;
    
    ButtonHandler  button;
    DisplayHandler disH;
  public:
  
    void gameStart(){
      boolean again = true;
      disH.writeSimpleString("Hit Button\nto Play");
      if(button.readState() == 1){
          game(10,5,10);
      }
      
    }
    
    void game(int w, int h, int numRect){
      int DELTAX = 2; 
      int t = 0;
      int space;
      // obstacle at player loction
      int near = 0;
      //obstacles position
      int obst[numRect][2];
      //player position
      int ply[3][2];
      // low = 0, high = 1;
      int stat =0;
      int validJump = 0;
      int score = 0;
      int delNum = 50;
      int endjump = 0;
    
      playing = true;
      //initialize obstacle location
      for(int f=0; f < numRect; f++){
        space = random(30,60);
        if (f==0){
          obst[f][XPOS] = disH.oled.width()-1;
        }
        else{
          obst[f][XPOS]   = obst[f-1][XPOS] + (w+space);
        } 
        obst[f][YPOS]   = disH.oled.height() - 6;
       }
    
      //Initialize player location
      ply[minJ][XPOS] = 10;
      ply[minJ][YPOS] = disH.oled.height()-10;
      ply[maxJ][XPOS] = 10;
      ply[maxJ][YPOS] = disH.oled.height()-20;
    
      //Set up printing characteristics 
    
      disH.oled.setTextSize(2);              // Normal 1:1 pixel scale
      disH.oled.setTextColor(SSD1306_WHITE); // Draw white text
      
      while(playing == true){
        if (score == 5){
        delNum = 40;
        }
        else if(score==10){
          delNum = 30;
        }
        else if (score==15){
          delNum = 10;
        }
        else if (score==20){
          delNum = 5;
        }
        else if (score==25){
          delNum = 2;
        }
        else if (score==30){
          delNum = 0;
        }
        delay(delNum);
        disH.oled.clearDisplay();
        
        //draw rectangles
        for(int f=0; f < numRect; f++) {
          if(obst[f][XPOS] <= disH.oled.width()-1 && obst[f][XPOS] >= 0){
            disH.oled.fillRect(obst[f][XPOS], obst[f][YPOS], w, h, WHITE);
            //player jumps
            if(button.readState() == 1 || t>0){
              disH.oled.drawRect(ply[maxJ][XPOS],ply[maxJ][YPOS], 10,10, WHITE);
              stat=1;
              t++;
            }
            if(t==0){
              disH.oled.drawRect(ply[minJ][XPOS],ply[minJ][YPOS], 10,10, WHITE);
              stat=0;
            }
            if(obst[f][XPOS] >= 0 && obst[f][XPOS] <=20){
              near = 1;
            }
            
            disH.oled.display();
          } 
        }
    
        //display current score
        disH.oled.setCursor(30, 0); 
        disH.oled.print("Score:"+ String(score));
        disH.oled.display();
        
        //Test if jumping over obstacle 
        if(near == 1 && stat == 1){
          validJump = 1;
        }
        
    
        if(near == 1 && stat == 0){
              playing = false;
              break;
            }
         
        if(t > 3.5*numRect){      // counter keeps player in "air" long enough to clear width of obstacle
          t=0;
          endjump = 1;
        }
        if(validJump == 1 && near == 0 && endjump == 1){      // updates score if jumped over obstacle
            score++;
            validJump = 0;
            endjump=0;
        }
        near = 0;
        //update rectangle location
        for(int f=0; f < numRect; f++) {
              obst[f][XPOS] -= DELTAX;
              space = random(30,60);
              // If rectangle is off the bottom of the screen...
              if (obst[f][XPOS] < 0) {
                if(f == 0){
                  if(obst[numRect-1][XPOS] > disH.oled.width()-5){
                    obst[f][XPOS]   = obst[numRect-1][XPOS] + w + space;
                  }
                  else{
                    obst[f][XPOS]   = disH.oled.width();           
                  }
                }
                else {
                 if(obst[f-1][XPOS] > disH.oled.width()-5){
                    obst[f][XPOS]   = obst[f-1][XPOS] + w + space;
                  }
                  else{
                    obst[f][XPOS]   = disH.oled.width();           
                  }
                }
              }
                // Reinitialize to a random position, just off the right
      
         }
    
      }
      //GAME OVER
     disH.oled.clearDisplay();
     disH.oled.setCursor(0,0);              // Start at top-left corner
     disH.oled.println("GAME OVER"); 
     //disH.writeSimpleString("GAME OVER");
     disH.oled.println("Score:" + String(score));
     disH.oled.display();
     delay(3000);
    }
};
