// Button press handler to identify button presses.
#ifndef ButtonHandler_h
#define ButtonHandler_h

// Pin that (external) button is connected to.
#define BUTTON_PIN 13

class ButtonHandler {
  private:
    int lastState = LOW; // Previous state of the button
    int currentState; // Current state of the button
    unsigned long pressedTime=0;
    unsigned long releasedTime=0;
    unsigned long lastClickedTime=0;
    int multiClickCounter = 0; 

    // Minimum length of time to be registered as long press
    const int LONG_PRESS_TIME=500; 
    // Max time between consecutive presses to be registered as a multi press
    const int MULTI_CLICK_MAX_TIME = 250; 

  public:
    int readState() {

      unsigned long currentTime = millis();
      currentState = digitalRead(BUTTON_PIN);
      int ret = -1; // Default no press read

      if (lastState==LOW && currentState== HIGH){ 
        // Button pressed
        pressedTime= currentTime;
        lastState = currentState;
        return ret;
      }

      // Button was released (That is, pressed then released)
      if(lastState == HIGH && currentState == LOW){ 
        releasedTime=currentTime;
        
        long pressDuration = releasedTime - pressedTime; //time between when button is pressed and then released
        
        //long press detected
        if(pressDuration > LONG_PRESS_TIME && multiClickCounter == 0){
          ret=0;  
        } 
        //short press detected
        else {
          multiClickCounter++;
          lastClickedTime = releasedTime;
        }  
      }

      if((currentTime - lastClickedTime) > MULTI_CLICK_MAX_TIME && multiClickCounter > 0) {
        ret = multiClickCounter;
        multiClickCounter = 0;
      }
        
      lastState = currentState;
      return ret;
    }
};

#endif
