// Feature screen handler
#ifndef ScreenHandler_h
#define ScreenHandler_h

#include <Arduino.h>

#define DELIMETER '|'

struct ScreenData {
  int screenNum;
  String screenInfo;
  int displayMode;
};

class ScreenHandler {
  public:
    void processIncomingData(std::string _data);
    
  private:
    ScreenData screenData;
    bool shouldRefreshScreen = false;

    void parseData(std::string _data);
    void refreshScreen();

    // Specific screen handling functions
    void screenOff();
    void screenTime();  
    void screenWeather();
    void screenGame();
};




#endif
