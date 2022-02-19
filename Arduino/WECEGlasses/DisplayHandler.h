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
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

class DisplayHandler {
  public:

    Adafruit_SSD1306 oled = Adafruit_SSD1306(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

    // TODO Add methods for writing information to screen
    void setup(){
      Serial.begin(9600);
  
      // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
      if(!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
        Serial.println(F("SSD1306 allocation failed"));
        for(;;); // Don't proceed, loop forever
      }
    
      // Show initial display buffer contents on the screen --
      // the library initializes this with an Adafruit splash screen.
      display.display();
      delay(2000); // Pause for 2 seconds
    
      // Clear the buffer
      display.clearDisplay();
    
      // Draw a single pixel in white
      display.drawPixel(10, 10, SSD1306_WHITE);
    
      // Show the display buffer on the screen. You MUST call display() after
      // drawing commands to make them visible on screen!
      display.display();
      delay(2000);
  
      testscrolltext();    // Draw scrolling text
        
      display.invertDisplay(true);
      delay(1000);
      display.invertDisplay(false);
      delay(1000);
    }

    /*
    void writeSimpleString(String text) {
      // Very simple example function for writing small text to screen
      oled.clearDisplay();
      
      oled.setTextSize(1);              // Normal 1:1 pixel scale
      oled.setTextColor(SSD1306_WHITE); // Draw white text
      oled.setCursor(0,0);              // Start at top-left corner
      
      oled.println(text); 

      // Pixels are only drawn to screen once display method is called
      oled.display();

      
    }
    */
     
    // Constructor
    void init() {
      Serial.println("Initializing display");
      
      // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
       if(!oled.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
        Serial.println("SSD1306 allocation failed");
        for(;;); // Don't proceed, loop forever
      }
      
      // TODO Add startup screen
      //#include
      /*
      const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
      LiquidCrystal lcd(rs, en, d4, d5, d6, d7);
      void setup() {
        lcd.begin(16, 2);
        lcd.print("hello, world!");
      }
      void loop() {
        lcd.setCursor(0, 1);
        lcd.print(millis() / 1000);
      }  
      */

      //writeSimpleString("WECE Glasses");
    }

  private:
  
};

#endif
