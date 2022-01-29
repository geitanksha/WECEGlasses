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
    const int SHORT_PRESS_TIME=1500;
    const int LONG_PRESS_TIME=1500;
     
    
  public:
    // Simple logic for reading a button click
    // TODO add handling to differentiate between long, short, and multi presses. 
    int readState() {
      int ret = 0; // Default no press read
      currentState = digitalRead(BUTTON_PIN);

      if(lastState == HIGH && currentState == LOW){ 
        // Button was released (That is, pressed then released)
        releasedTime=millis();
        long pressDuration=releasedTime-pressedTime;
        if (pressDuration<SHORT_PRESS_TIME)
          ret=1; //short press detected

        if( pressDuration > LONG_PRESS_TIME )
          ret=2;  //long press detected
      }
      else if(lastState==LOW && currentState== HIGH){ 
         pressedTime= millis();
      }
         

      lastState = currentState;
      return ret;
    }
};

#endif
