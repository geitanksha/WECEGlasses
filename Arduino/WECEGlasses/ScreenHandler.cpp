#include "ScreenHandler.h"

void ScreenHandler::processOutgoingData(std::string _data) {
  // TODO add any local processing of button clicks, for example for the game
}

void ScreenHandler::processIncomingData(std::string _data) {
  parseData(_data);
  if(shouldRefreshScreen) {
    refreshScreen();
  }
}

void ScreenHandler::parseData(std::string _data) {
  // Processing screen change data
  String screenDataTemp[3];
  if(_data[0] == '#') {
    // Split string by delimeter
    int arrIdx = 0;
    String val = "";
    for(int i = 1; i < _data.length(); i++) {
      if(_data[i] == DELIMETER) {
        screenDataTemp[arrIdx] = val;
        val = "";
        arrIdx++;
      } else {
        val+= _data[i];
      }
    }

    screenData.screenNum = screenDataTemp[0].toInt();
    screenData.screenInfo = screenDataTemp[1];
    screenData.displayMode = screenDataTemp[2].toInt();
    
    shouldRefreshScreen = true;
  }

  // Other type of data processing if needed
}

void ScreenHandler::refreshScreen() {

  switch(screenData.screenNum) {
    case 0: screenOff(); break;
    case 1: screenTime(); break;
    case 2: screenWeather(); break;
    case 3: screenGame(); break;
  }
 
  shouldRefreshScreen = false;
}

void ScreenHandler::screenOff() {
  displayHandler.oled.clearDisplay();
}

void ScreenHandler::init() {
  displayHandler.init();
}

void ScreenHandler::screenTime() {
  // TODO nicer formatting
  displayHandler.writeSimpleString(screenData.screenInfo);
}

void ScreenHandler::screenWeather() {
  // TODO nicer formatting
  displayHandler.writeSimpleString(screenData.screenInfo + char(247) + "F"); 
}

void ScreenHandler::screenGame() {
  
}
