// ESP32 device code main for WECEGlasses
#include "BLEHandler.h"
#include "ScreenHandler.h"
#include "ButtonHandler.h"

ButtonHandler button;
ScreenHandler screenHandler;
BLEHandler ble;

void setup() {
  Serial.begin(115200); // Printing for debugging/logging
  ble.init();
  screenHandler.init();
}

void loop() {
  // Check for new data
  if(ble.isDataAvailable()) {
    screenHandler.processIncomingData(ble.getData());
  }
  
  if (screenHandler.game.isPlaying()){
    screenHandler.game.gamePlay();
  }
  
  // Process button clicks
  int state = button.readState();
  if(state == 1) {
    Serial.println("Short press detected.");
    ble.notify("1");
    screenHandler.processOutgoingData("1");
  } else if(state == 2){
    Serial.println("Long press detected.");
    ble.notify("2");
    screenHandler.processOutgoingData("2");
  }
}
