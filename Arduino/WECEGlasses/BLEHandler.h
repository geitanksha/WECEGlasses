#ifndef BLEHandler_h // Prevents double import 
#define BLEHandler_h

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#include <Arduino.h> // For Serial.print()

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

// Entire class definition should't really be in header file, but this is fine for now.
class BLEHandler {
  private:
    BLEServer* pServer = NULL;
    BLECharacteristic* pCharacteristic = NULL;
    BLEAdvertising *pAdvertising = NULL;
    
    bool deviceConnected = false;

    bool dataAvailable = false; // Whether data is available
    String dataReceived; // Actual data that was recieved 

    // Callback class for handling device connect/disconnect
    class ServerCallbacks: public BLEServerCallbacks {
      // Give class reference to the encapsulating class so we can use its members
      BLEHandler &outer;
      public:
        ServerCallbacks(BLEHandler &outer_) : outer(outer_) {}
      
      void onConnect(BLEServer* pServer) {
        outer.deviceConnected = true;
        Serial.println("Device Connected");
      };
  
      void onDisconnect(BLEServer* pServer) {
        outer.deviceConnected = false;
        Serial.println("Device Disconnected");
      }
    };

    // Callback class for handling incoming data
    class CharacteristicCallbacks: public BLECharacteristicCallbacks {
      // Give class reference to the encapsulating class so we can use its members
      BLEHandler &outer;
      public:
        CharacteristicCallbacks(BLEHandler &outer_) : outer(outer_) {}
 
      void onWrite(BLECharacteristic *pCharacteristic) {
        String value = pCharacteristic->getValue().c_str();
        outer.dataAvailable = true;
        outer.dataReceived = value;
      }
    };

  public:
    bool isDeviceConnected() {
      return deviceConnected;
    }
    
    bool isDataAvailable(){
      return dataAvailable;
    }

    String getData() {
      return dataReceived;
      dataAvailable = false;
    }

    void checkConnection() {
      if(!deviceConnected) {
        delay(500); // Give the bluetooth stack the chance to get things ready
        pAdvertising->start(); 
        Serial.println("Started Advertising");
      }
    }

    void init() {
      // Create device
      BLEDevice::init("WECEGlasses"); // Name of device

      // Create server
      pServer = BLEDevice::createServer();
      pServer->setCallbacks(new ServerCallbacks(*this));

      // Create service
      BLEService *pService = pServer->createService(SERVICE_UUID);
    
      pCharacteristic = pService->createCharacteristic(
                                 CHARACTERISTIC_UUID,
                                 BLECharacteristic::PROPERTY_READ |
                                 BLECharacteristic::PROPERTY_WRITE |
                                 BLECharacteristic::PROPERTY_NOTIFY |
                                 BLECharacteristic::PROPERTY_INDICATE
                               );
      pCharacteristic->setCallbacks(new CharacteristicCallbacks(*this));

      pService->start();
      
      pAdvertising = pServer->getAdvertising();
      // Will start advertising in loop
    }
};

#endif
