//#include <Console.h>
#include <YunClient.h>

#define ARDUINO_PLATFORM
#include "M2XStreamClient.h"


char deviceId[] = "a0b52f8541b7e2a4a35617d42f6efe5d"; // Device you want to push to
char streamName[] = "MQ4"; // Stream you want to push to
char m2xKey[] = "9875a0904ad6ff8c46a0ed47dd1730c3"; // Your M2X access key

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
