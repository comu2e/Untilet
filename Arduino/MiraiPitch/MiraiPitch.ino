//#include <Console.h>
#include <YunClient.h>

#define ARDUINO_PLATFORM
#include "M2XStreamClient.h"


char deviceId[] = "4cd5ec82a8b2f839555cfb618d6dbad5"; // Device you want to push to
char streamName[] = "MQ4"; // Stream you want to push to
char m2xKey[] = "76bc32ad813883778b2b7fa95dbd4160"; // Your M2X access key

char incomingByte;      // a variable to read incoming Console data into
const int sensorPin = A5;

YunClient client;
M2XStreamClient m2xClient(&client, m2xKey);

void setup() {
  Bridge.begin();   // Initialize Bridge
//  Console.begin();  // Initialize Console
}

void loop() {
  int sensorVal = analogRead(sensorPin);
  int response = m2xClient.updateStreamValue(deviceId, streamName, sensorVal);
  delay(1000);
}

