// Arduino main for WECEGlasses
#include "BLEHandler.h"
#include "DisplayHandler.h"

BLEHandler ble;
DisplayHandler displayHandler;

void setup() {
  Serial.begin(115200); // Printing for debugging/logging

  ble.init();
  displayHandler.init();

}

void loop() {
  // Example of how bluetooth reading might work
  // If bluetooth data available, write data to screen
  if (ble.dataAvailable()) {
    displayHandler.writeSimpleString(ble.getData());
  }

}
