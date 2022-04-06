#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#include <Arduino.h>
#include "DisplayHandler.h"
#include "ScreenHandler.h"

class Game {
  private:
    int XPOS = 0;
    int YPOS = 1;
    int maxJ = 1;
    int minJ = 0;
    int DELTAX = 2; 
    int space;
    // obstacle at player loction
    int near = 0;
    //obstacles position
    int obst[10][2];
    //player position
    int ply[3][2];
    int stat =0;
    int validJump = 0;
    int score = 0;
    int delNum = 50;
    int endjump = 0;
    int hit = 0;
    boolean playing = false;
    int t = 0;
    boolean wait_to_play = true;
    
    DisplayHandler *disH;
    
  public:
    void init(DisplayHandler *dh){
      disH = dh;
    }
    
    // if currenly in game
    boolean isPlaying(){
      return playing;
    }

    int current_t(){
      return t;
    }

   // what to do when player jumps
    void onJump(){   
        disH->oled.drawRect(ply[maxJ][XPOS],ply[maxJ][YPOS], 10,10, WHITE);
        stat=1;
        t++;
    }

    // whether or not the player in on the pre-game screen
    boolean isWaiting(){ 
      return wait_to_play;
    }


    // beginning of game
    void gameStart(){
      wait_to_play = true;
      disH->writeSimpleString("Hit Button\nto Play");                                
      /*if(button.readState() == 1){
          initGame();
          gamePlay();         // called in ScreenHandler.cpp
      } */ 
    }
    
    // initialize game variables
    void initGame(){
      playing = true;
      wait_to_play = false;
      hit = 0;
      stat = 0;
      validJump = 0;
      score = 0;
      endjump = 0;
      t = 0;
      //initialize obstacle location
      for(int f=0; f < 10; f++){
        space = random(30,60);
        if (f==0){
          obst[f][XPOS] = disH->oled.width()-1;
        }
        else{
          obst[f][XPOS]   = obst[f-1][XPOS] + (10+space);
        } 
        obst[f][YPOS]   = disH->oled.height() - 6;
       }
    
      //Initialize player location
      ply[minJ][XPOS] = 10;
      ply[minJ][YPOS] = disH->oled.height()-10;
      ply[maxJ][XPOS] = 10;
      ply[maxJ][YPOS] = disH->oled.height()-20;
    
      //Set up printing characteristics 
    
      disH->oled.setTextSize(2);              // Normal 1:1 pixel scale
      disH->oled.setTextColor(SSD1306_WHITE); // Draw white text
    }
    
    void gamePlay(){ 
     if (playing == true){
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
      disH->oled.clearDisplay();
      
      //draw rectangles
      for(int f=0; f < 10; f++) {
        if(obst[f][XPOS] <= disH->oled.width()-1 && obst[f][XPOS] >= 0 && playing == true){
          disH->oled.fillRect(obst[f][XPOS], obst[f][YPOS], 10, 5, WHITE);
          //player jumps
          /*if(button.readState() == 1 || t>0){                                                       //Button click effect in screenHandler.cpp
            disH->oled.drawRect(ply[maxJ][XPOS],ply[maxJ][YPOS], 10,10, WHITE);
            stat=1;
            t++;
          }*/
          if (t>=1){
            t++;
            disH->oled.drawRect(ply[maxJ][XPOS],ply[maxJ][YPOS], 10,10, WHITE);
          }
          else if(t==0){
            disH->oled.drawRect(ply[minJ][XPOS],ply[minJ][YPOS], 10,10, WHITE);
            stat=0;
          }
          if(obst[f][XPOS] >= 0 && obst[f][XPOS] <=20){
            near = 1;
          }
          
          disH->oled.display();
        } 
      }
  
      //display current score
      disH->oled.setCursor(30, 0); 
      disH->oled.print("Score:"+ String(score));
      disH->oled.display();
      
      //Test if jumping over obstacle 
      if(near == 1 && stat == 1){
        validJump = 1;
      }
      
      //HIT???
      if(near == 1 && stat == 0){
            hit = 1;
          }
       
      if(t > 3.5*10){      // counter keeps player in "air" long enough to clear width of obstacle
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
      for(int f=0; f < 10; f++) {
            obst[f][XPOS] -= DELTAX;
            space = random(30,60);
            // If rectangle is off the bottom of the screen...
            if (obst[f][XPOS] < 0) {
              if(f == 0){
                if(obst[10-1][XPOS] > disH->oled.width()-5){
                  obst[f][XPOS]   = obst[10-1][XPOS] + 10 + space;
                }
                else{
                  obst[f][XPOS]   = disH->oled.width();           
                }
              }
              else {
               if(obst[f-1][XPOS] > disH->oled.width()-5){
                  obst[f][XPOS]   = obst[f-1][XPOS] + 10 + space;
                }
                else{
                  obst[f][XPOS]   = disH->oled.width();           
                }
              }
            }
              // Reinitialize to a random position, just off the right
    
       }
      if(hit == 1){
        gameOver();
      }
     }
    }

    // game over end screen
    void gameOver(){
       //GAME OVER
       disH->oled.clearDisplay();
       disH->oled.setCursor(0,0);              // Start at top-left corner
       disH->oled.println("GAME OVER"); 
       //disH->writeSimpleString("GAME OVER");
       disH->oled.println("Score:" + String(score));
       disH->oled.display();
       hit = 0;
       delay(1000);
       playing = false;
       gameStart();
    }

    // end game prematurely
    void cancel(){
      playing = false;
    }

};

// cancel function
// game play function  x
// variables as class varaibles x
// initialization function x
