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
    
    void writeString(String text) {
      // Very simple example function for writing small text to screen
      oled.clearDisplay();
      
      oled.setTextSize(1);              // Normal 1:1 pixel scale
      oled.setTextColor(SSD1306_WHITE); // Draw white text
      oled.setCursor(0,0);              // Start at top-left corner
      
      oled.println(text); 

      // Pixels are only drawn to screen once display method is called
      oled.display();
    }
    
    // Constructor
    void init() {
      Serial.println("Initializing display");
      
      // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
       if(!oled.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
        Serial.println("SSD1306 allocation failed");
        for(;;); // Don't proceed, loop forever
      }
      
      startUp();
    }

  private:
    void startUp() {
      drawline();
      scrolltext("WECEGlasses! ");    // Draw scrolling text
      drawReverse();
      oled.clearDisplay();
      oled.display();
    }
    
    void drawline() {
      int16_t i;
    
      oled.clearDisplay(); // Clear display buffer
    
      for(i=0; i<oled.width(); i+=4) {
        oled.drawLine(0, 0, i, oled.height()-1, SSD1306_WHITE);
        oled.display(); // Update screen with each newly-drawn line
        delay(1);
      }
      for(i=0; i<oled.height(); i+=4) {
        oled.drawLine(0, 0, oled.width()-1, i, SSD1306_WHITE);
        oled.display();
        delay(1);
      }
      delay(250);
    
      oled.clearDisplay();
    
      for(i=0; i<oled.width(); i+=4) {
        oled.drawLine(0, oled.height()-1, i, 0, SSD1306_WHITE);
        oled.display();
        delay(1);
      }
      for(i=oled.height()-1; i>=0; i-=4) {
        oled.drawLine(0, oled.height()-1, oled.width()-1, i, SSD1306_WHITE);
        oled.display();
        delay(1);
      }
      delay(250);
    }

  void drawReverse(){
    int16_t i;
    
    oled.clearDisplay();

    for(i=oled.width()-1; i>=0; i-=4) {
      oled.drawLine(oled.width()-1, oled.height()-1, i, 0, SSD1306_WHITE);
      oled.display();
      delay(1);
    }
    for(i=oled.height()-1; i>=0; i-=4) {
      oled.drawLine(oled.width()-1, oled.height()-1, 0, i, SSD1306_WHITE);
      oled.display();
      delay(1);
    }
    delay(250);
  
    oled.clearDisplay();
  
    for(i=0; i<oled.height(); i+=4) {
      oled.drawLine(oled.width()-1, 0, 0, i, SSD1306_WHITE);
      oled.display();
      delay(1);
    }
    for(i=0; i<oled.width(); i+=4) {
      oled.drawLine(oled.width()-1, 0, i, oled.height()-1, SSD1306_WHITE);
      oled.display();
      delay(1);
    }
  
    delay(2000); // Pause for 2 seconds
  }

  void scrolltext(String text){
    oled.clearDisplay();
  
    oled.setTextSize(1); // Draw 1X-scale text
    oled.setTextColor(SSD1306_WHITE);
    oled.setCursor(0, 0);
    oled.println(text);
    oled.display();   
    delay(100);
  
    // Scroll in various directions, pausing in-between:
    oled.startscrollleft(0x00, 0x2F);
    delay(5000);
    oled.stopscroll();
    delay(1000);
    oled.startscrolldiagright(0x00, 0x07);
    delay(5000);
    oled.stopscroll();
    delay(1000);
  }
  
};

#endif
