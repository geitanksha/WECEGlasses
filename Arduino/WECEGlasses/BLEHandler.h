#ifndef BLEHandler_h // Prevents double import 
#define BLEHandler_h

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>

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

    String receivedData;
    bool dataAvail = false;

    class ServerCallbacks: public BLEServerCallbacks {
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

    class Callback: public BLECharacteristicCallbacks {
      
      // Give class reference to the encapsulating class so we can use its members
      BLEHandler &outer;
      public:
        Callback(BLEHandler &outer_) : outer(outer_) {}
 
      void onWrite(BLECharacteristic *pCharacteristic) {
        String value = pCharacteristic->getValue().c_str();
        outer.dataAvail = true;
        outer.receivedData = value;
      }
    };

    Callback *callback = new Callback(*this);
    
  public:
    bool getDeviceConnected() {
      return deviceConnected;
    }
    
    bool dataAvailable(){
      return dataAvail;
    }

    String getData() {
      return receivedData;
      dataAvail = false;
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
      pCharacteristic->setCallbacks(callback);

      pService->start();
      
      pAdvertising = pServer->getAdvertising();
      // Will start advertising in loop
    }
};

#endif
