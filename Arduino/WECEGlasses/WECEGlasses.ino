// ESP32 device code main for WECEGlasses
#include "BLEHandler.h"
#include "DisplayHandler.h"
#include "ButtonHandler.h"


DisplayHandler displayHandler;
BLEHandler ble;
ButtonHandler button;
ScreenHandler screenHandler;

void setup() {
  Serial.begin(115200); // Printing for debugging/logging12
  displayHandler.init();
  screenHandler.init(displayHandler);
  ble.init(screenHandler);
}

void loop() {
  // Process button clicks
  if(button.readState() == 1) {
    // TODO Change to long click for screen change
    Serial.println("Button click detected.");
    ble.notify("1");
  }
}
