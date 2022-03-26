// ESP32 device code main for WECEGlasses
#include "BLEHandler.h"
#include "DisplayHandler.h"
#include "ButtonHandler.h"

ButtonHandler button;
ScreenHandler screenHandler;
BLEHandler ble;

void setup() {
  Serial.begin(115200); // Printing for debugging/logging
  screenHandler.init();
  ble.init();
}

void loop() {
  // Check for new data
  if(ble.isDataAvailable()) {
    screenHandler.processIncomingData(ble.getData());
  }
  
  // Process button clicks
  if(button.readState() == 1) {
    // TODO Change to long click for screen change
    Serial.println("Button click detected.");
    ble.notify("1");
    screenHandler.processOutgoingData("1");
  }
}
