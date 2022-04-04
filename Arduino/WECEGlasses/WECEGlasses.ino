// ESP32 device code main for WECEGlasses
#include "BLEHandler.h"
#include "DisplayHandler.h"
#include "ButtonHandler.h"
#include "Game.h"

BLEHandler ble;
DisplayHandler displayHandler;
ButtonHandler button;
Game  game;

uint32_t val = 0; // Temporary for debugging

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
    displayHandler.writeString(ble.getData());
  }

  // Process button clicks
  int state = button.readState();
  if(state == 1) {
    Serial.println("Short press detected.");
    ble.notify("1");
  } if(state == 2){
    Serial.println("Long press detected.");
    ble.notify("2");
  }
}
