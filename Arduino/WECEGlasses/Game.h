#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include ButtonHandler.h // Use this for button?? 

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels

#define OLED_RESET     4 // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

boolean hit = false;
boolean playing = false;
int button_state = 0;

void setup() {
  Serial.begin(9600);

  // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
  if(!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
 }

 display.display();
 delay(2000);
 display,clearDisplay();
 
 while(!playing){         // start screen
  
    display.setTextSize(2);             // Draw 2X-scale text
    display.setTextColor(SSD1306_WHITE);
    display.print(F("Shooting Star!")); display.println(F("Press button to start!"));
    button_state= digitalRead(BUTTON_PIN);      // CHANGE ONCE BUTTON FUNCTION DECIDED
    if (button_state == 1){
      playing = true;
    }
    
 }
void moverect(void) {
  display.clearDisplay();

  for(int16_t i=0; i<display.height()/2; i+=3) {
    display.fillRect(i, i, display.width()-i*2, display.height()-i*2, SSD1306_BLACK);
    display.display(); // Update screen with each newly-drawn rectangle
    delay(1);
  }
moverect();
  delay(200);

#define XPOS   0 // Indexes into the 'obstacles' array in function below
#define YPOS   1
#define DELTAX 2
#define NUMRECT 10 // FIND WAY TO MAKE THESE GOING UNTIL HIT

void testanimate(const uint8_t *bitmap, uint8_t w, uint8_t h) {
  int8_t f, obstacles[NUMRECT][3];

  // Initialize 'snowflake' positions
  for(f=0; f< NUMRECT; f++) {
    obstacles[f][XPOS]   = display.width();
    obstacles[f][YPOS]   = display.height() - 5;
    obstacles[f][DELTAX] = random(1, 6);
    Serial.print(F("x: "));
    Serial.print(obstacles[f][XPOS], DEC);
    Serial.print(F(" y: "));
    Serial.print(obstacles[f][YPOS], DEC);
    Serial.print(F(" dy: "));
    Serial.println(obstacles[f][DELTAY], DEC);
  }

  for(;;) { // Loop forever...
    display.clearDisplay(); // Clear the display buffer

    // Draw each snowflake:
    for(f=0; f< NUMRECT; f++) {
      display.fillRect(obstacles[f][XPOS], obstacles[f][YPOS], w, h, SSD1306_BLACK);
    }

    display.display(); // Show the display buffer on the screen
    delay(200);        // Pause for 1/10 second

    // Then update coordinates of each flake...
    for(f=0; f< NUMRECT; f++) {
      obstacles[f][XPOS] -= obstacles[f][DELTAX];
      // If snowflake is off the bottom of the screen...
      if (obstacles[f][XPOS] <= display.width()) {
        // Reinitialize to a random position, just off the top
        obstacles[f][XPOS]   = random(1 - LOGO_WIDTH, display.width());
        obstacles[f][YPOS]   = -LOGO_HEIGHT;
        obstacles[f][DELTAX] = random(1, 6);
      }
    }
  }
}
