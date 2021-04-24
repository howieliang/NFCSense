//*********************************************
// Arduino Codes for NFCSense, which is based on
// - NXP MFRC522 NFC/RFID Reader (e.g., RFID RC522)
// - RFID.cpp Library (created by Dr. Leong and Miguel Balboa)
// for further information please check 
// our website: https://ronghaoliang.page/NFCSense
// or contact Dr. Rong-Hao Liang (TU Eindhoven) via r.liang@tue.nl
//*********************************************

#include <SPI.h> 
#include "RFID.h"
#define SS_PIN 10
#define RST_PIN 9
#define UID_BITNUM 5 //The 5-bit UID, including the 1-bit ECC

#define REFRESH_RATE 300 //unit: Hz
//Recommended parameters: 300 for Arduino Uno and Leonardo, 250 for ESP32, 200 for Teensy 3.2

RFID rfid(SS_PIN, RST_PIN);
int UID[UID_BITNUM]; //UID: Unique IDentifier
long timer = micros(); //timer

void setup()
{
  Serial.begin(115200);
  SPI.begin();
  rfid.init();
  for (int i = 0 ; i < UID_BITNUM ; i++)  UID[i] = -1;
} 

void loop()
{
  if (micros() - timer >= (1000000/REFRESH_RATE) ) { //Timer: send sensor data in every 10ms
    timer = micros();
    if (rfid.isCard()) {  // A tag is detected
      if (rfid.readCardSerial()) { // Read the tag's ID
        for (int i = 0 ; i < UID_BITNUM ; i++)  UID[i] = rfid.serNum[i]; //UID=UID
      }
    } 
    else { // No tag is detected.
      for (int i = 0 ; i < UID_BITNUM ; i++)  UID[i] = 256; //256: absence
    }
    printInSerialPlotter(UID);
    rfid.halt(); //Halt the rfid reader
  }
}

void printInSerialPlotter(int UID[]) { //println(uid[0],uid[1],uid[2],uid[3],uid[4]);
  for(int i=0; i< UID_BITNUM; i++){
    Serial.print(UID[i]);
    (i<4 ? Serial.print(','): Serial.println());
  }
}
