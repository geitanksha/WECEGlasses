// ESP32 device code main for WECEGlasses
#include "BLEHandler.h"
#include "DisplayHandler.h"
#include "ButtonHandler.h"
#include "Game.h"

ButtonHandler button;
Game  game;

uint32_t val = 0; // Temporary for debugging
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
