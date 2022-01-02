// ESP32 device code main for WECEGlasses
#include "BLEHandler.h"
#include "DisplayHandler.h"
#include "ButtonHandler.h"

BLEHandler ble;
DisplayHandler displayHandler;
ButtonHandler button;

void setup() {
  Serial.begin(115200); // Printing for debugging/logging

  ble.init();
  displayHandler.init();
}

void loop() {
  // Example of how bluetooth reading might work
  // If bluetooth data available, write data to screen
  if (ble.isDataAvailable()) {
    // TODO Add specialized data handling
    displayHandler.writeSimpleString(ble.getData());
  }

  // Process button clicks
  if(button.readState() == 1) {
    Serial.println("Button click detected.");
    ble.notify("1");
  }
}
