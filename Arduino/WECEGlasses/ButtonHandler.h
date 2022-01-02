// Button press handler to identify button presses.
#ifndef ButtonHandler_h
#define ButtonHandler_h

// Pin that button is connected to.
// TODO pin 0 is the onboard button--this will change once external button added
#define BUTTON_PIN 0

class ButtonHandler {
  private:
    int lastState = LOW; // Previous state of the button
    int currentState; // Current state of the button
    
  public:
    // Simple logic for reading a button click
    // TODO add handling to differentiate between long, short, and multi presses. 
    int readState() {
      int ret = 0; // Default no press read
      
      // TODO remove logical not -- onboard push button has opposite state readings
      currentState = !digitalRead(BUTTON_PIN);

      if(lastState == HIGH && currentState == LOW) {
        // Button was released (That is, pressed then released)
        ret = 1;
      }

      lastState = currentState;
      return ret;
    }
};

#endif
