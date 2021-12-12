#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#include <Arduino.h> // For Serial.print()

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

// Entire class definition should't really be in header file, but this is fine for now.
class BLEHandler {
  private:
    std::string receivedData;
    bool dataAvail = false;

    class Callback: public BLECharacteristicCallbacks {
      
      // Give class reference to the encapsulating class so we can use its members
      BLEHandler &outer;
      public:
        Callback(BLEHandler &outer_) : outer(outer_) {}
 
      void onWrite(BLECharacteristic *pCharacteristic) {
        std::string value = pCharacteristic->getValue();
        outer.dataAvail = true;
        outer.receivedData = value;
        
        if (value.length() > 0) {
          Serial.println("*********");
          Serial.print("New value: ");
          for (int i = 0; i < value.length(); i++)
            Serial.print(value[i]);
  
          Serial.println();
          Serial.println("*********");
        }
      }
    };

    Callback *callback = new Callback(*this);
    
  public:
    bool dataAvailable(){
      return dataAvail;
    }

    std::string getData() {
      if (dataAvail) {
        return receivedData;
        dataAvail = false;
      } else {
        // throw error?
      }
    }

    void init() {
      BLEDevice::init("WECEGlasses"); // Name of device
      BLEServer *pServer = BLEDevice::createServer();
    
      BLEService *pService = pServer->createService(SERVICE_UUID);
    
      BLECharacteristic *pCharacteristic = pService->createCharacteristic(
                                             CHARACTERISTIC_UUID,
                                             BLECharacteristic::PROPERTY_READ |
                                             BLECharacteristic::PROPERTY_WRITE
                                           );

      pCharacteristic->setCallbacks(callback);
    
      pCharacteristic->setValue("Hello World");
      pService->start();
    
      BLEAdvertising *pAdvertising = pServer->getAdvertising();
      pAdvertising->start();
    }
};
