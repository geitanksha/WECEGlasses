// Arduino main for WECEGlasses
#include "BLEHandler.h"

BLEHandler ble;

void setup() {
  Serial.begin(115200); // Printing for debugging/logging
  
  ble.init();
}

void loop() {}
