// OLED display handler
#ifndef DisplayHandler_h
#define DisplayHandler_h

#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#include <Arduino.h>

// Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)
// The pins for I2C are defined by the Wire-library. 
// For the Sparkfun ESP32:       21 (GPIO 22) > SDA, SCL (GPIO 22) > SCL
#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels
#define OLED_RESET     4 // Reset pin 
#define SCREEN_ADDRESS 0x3C 

class DisplayHandler {
  public:

    Adafruit_SSD1306 oled = Adafruit_SSD1306(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

    // TODO Add methods for writing information to screen
    
    // Constructor
    void init() {
      Serial.println("Initializing display");
      
      // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
       if(!oled.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
        Serial.println("SSD1306 allocation failed");
        for(;;); // Don't proceed, loop forever
      }
      
      oled.clearDisplay();

      // TODO Add startup screen
      // Here's a basic example
      oled.setTextSize(1);              // Normal 1:1 pixel scale
      oled.setTextColor(SSD1306_WHITE); // Draw white text
      oled.setCursor(0,0);              // Start at top-left corner
      oled.println("WECE Glasses");

      // Pixels are only drawn to screen once display method is called
      oled.display(); 
    }

    
  private:
  
};

#endif
