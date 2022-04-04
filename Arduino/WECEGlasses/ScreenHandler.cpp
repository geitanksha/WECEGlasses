#include "ScreenHandler.h"

void ScreenHandler::processOutgoingData(std::string _data) {
  // TODO add any local processing of button clicks, for example for the game
  if(game.isPlaying()){
    if (game.isWaiting() == true && _data == "1"){
      game.initGame();
      game.gamePlay();
    }
    if (game.isWaiting() == false && (_data == "1" || game.current_t()>0)){
        game.onJump();
    } 
  }
}

void ScreenHandler::processIncomingData(std::string _data) {
  for(int i=0; i<_data.length(); i++) {
    Serial.print(_data[i]);
  }
  Serial.println();
  parseData(_data);
  if(shouldRefreshScreen) {
    Serial.println("Refreshing Screen");
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
    screenDataTemp[arrIdx] = val;
    
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
  displayHandler.oled.display();
}

void ScreenHandler::init() {
  displayHandler.init();
  game.init(displayHandler);
}

void ScreenHandler::screenTime() {
  displayHandler.writeSimpleString(screenData.screenInfo);
}

void ScreenHandler::screenWeather() {
  if(screenData.displayMode == 1) {
    displayHandler.writeSimpleString(screenData.screenInfo);
  } else {
    displayHandler.writeSimpleString(screenData.screenInfo + char(247) + "F"); 
  }
  
}

void ScreenHandler::screenGame() {
  if(screenData.displayMode == 0){
    game.gameStart();
  }
  if(screenData.displayMode == 1){
    game.cancel();
  }
}
