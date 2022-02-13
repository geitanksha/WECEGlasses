// Button press handler to identify button presses.
#ifndef ButtonHandler_h
#define ButtonHandler_h
#include <millisDelay.h>

// Pin that (external) button is connected to.
#define BUTTON_PIN 13

class ButtonHandler {
  private:
    int lastState = LOW; // Previous state of the button
    int currentState; // Current state of the button
    unsigned long pressedTime=0;
    unsigned long releasedTime=0;
    const int PRESS_TIME=1500;
    int double_count = 0; 
    const int time_btwn = 500;
    millisDelay shortDelay;
    
  public:
    // Simple logic for reading a button click
    int readState() {
      
      int ret = 0; // Default no press read
      currentState = digitalRead(BUTTON_PIN);
 

      // Button was released (That is, pressed then released)
      if(lastState == HIGH && currentState == LOW){ 
        releasedTime=millis();
        
        long pressDuration = releasedTime - pressedTime; //time between when button is pressed and then released
        long btwnDuration = pressedTime - releasedTime; //time between when button is released and then pressed
        
        //long press detected
        if(pressDuration > PRESS_TIME){
          ret=2;  
          } 
        
        //short press detected
        else{
             if(double_count == 1){ //second double click (should ignore it and NOT detect as a new short press
                double_count = 0; //reset double click count
               } 
               
             else{
                shortDelay.start(750); //set up timer
                //check if button is pressed again while timer is not done
                while(!(shortDelay.justFinished())){ 
                     if(digitalRead(BUTTON_PIN) == HIGH){
                        ret = 3; //if pressed then double click is detected
                        double_count = 1;
                        break; 
                       }
                     ret = 1; //if not pressed during timer, then short press is detected
                    }
                 }
           }   
       
      }

      else if (lastState==LOW && currentState== HIGH){ 
              pressedTime= millis();
              }
        
      lastState = currentState;
      return ret;
    }
};

#endif
