#include "FirebaseESP8266.h"
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <hcsr04.h>

#define FIREBASE_HOST "datn-water-level.firebaseio.com"
#define FIREBASE_AUTH "ROI87n0V3VwlaBKnAXJh8RxkHt8wAcOGxhDbCWW7"
//#define WIFI_SSID "xnxx"
//#define WIFI_PASSWORD "tung.tung"

#define TRIG_PIN 12
#define ECHO_PIN 14

#define EQUIP_ID "5ccb0a9be998112d4c017902"

String jsonStr;

//Define FirebaseESP8266 data object
FirebaseData firebaseData;
String path = "data/water_level/";

ESP8266WebServer serverAP(80);
HCSR04 hcsr04(TRIG_PIN, ECHO_PIN, 20, 5000);

// Code for Access point
const char index_html[] PROGMEM = "<!DOCTYPE html> <html> <head> <title>Enter wifi</title>"
  "<style type='text/css'> input { height: 20px; width: 200px;}"
  "body {padding-top: 50px; text-align: center;} .main {padding: auto;}"
  "label{padding-left: 50px; margin-right: 20px; display: inline-block; width: 100px;}"
  "</style> </head> <body> <div id='main'> <h1>Enter SSID Wifi</h1><hr> "
  "<form action='./submit' method='GET's>"
  "<label>SSID: </label> <input type='text' name='ssid' required> <br>"
  "<label>PASS:</label> <input type='password' name='password' required minlength=8> <br> "
  "<input type='submit' value='Submit'> </form> </div> </body> </html>"; 

bool isConnectionAvailable = false;

void handleRoot() {
  serverAP.send(200, "text/html", index_html);
}

void handleGetSSID() {
  String message = "Number of args received:";
  String ssid = "";
  String pass = "";
  bool haveSsid = false;
  bool havePass = false;

  message += serverAP.args();
  message += "\n";
  
  for (int i = 0; i < serverAP.args(); i++) {
    if (serverAP.argName(i).equals("ssid")) {
      haveSsid = true;
      ssid = serverAP.arg(i);
    }
    if (serverAP.argName(i).equals("password")) {
      havePass = true;
      pass = serverAP.arg(i);
    }
    message += "Arg name" + (String)i + " --> ";
    message += serverAP.argName(i) + ": ";
    message += serverAP.arg(i) + "\n";
  }

  if (haveSsid && havePass && !isConnectionAvailable) {
    message += "Preparing for connect";
    serverAP.send(200, "text/plain", message);
    Serial.println("Prepare for connect");
    delay(5000);
    Serial.println("Disconnect AP");
    WiFi.softAPdisconnect (true);
    delay(100);
    Serial.println("Connect to SSID " + ssid);
    WiFi.begin(ssid, pass);

    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
    
    Serial.println("Connected to SSID " + ssid);
    isConnectionAvailable = true;
    Serial.println(WiFi.localIP());
    // Start firebase
    setupFirebase();
  } else {
    serverAP.send(200, "text/plain", message);
  }
}

void handleNotFound() {
  serverAP.send(200, "text/plain", "<H2>Page not found</H2>");
}

bool connectWifi() {
  Serial.println("Connect to last SSID");
  WiFi.mode(WIFI_STA);
  WiFi.begin();

  byte countFail = 0;

  while (WiFi.status() != WL_CONNECTED && countFail < 120) {
    delay(500);
    Serial.print(".");
    countFail++;
  }

  if (countFail >= 120) {
    Serial.println("Connect timeout");
    return false;
  } else {
    Serial.println("Connected to last SSID");
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
    isConnectionAvailable = true;
    return true;
  }
}

void configAccessPoint() {
  Serial.println("Configuring access point...");
  WiFi.softAP("ESP8266", "12345678");
  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
}

void setupAP() {
  serverAP.on("/", handleRoot);
  serverAP.on("/submit", handleGetSSID);
  serverAP.onNotFound(handleNotFound);
  serverAP.begin();
}

void setupFirebase() {
  digitalWrite(LED_BUILTIN, LOW);
  delay(500);
  digitalWrite(LED_BUILTIN, HIGH);
  delay(200);
  digitalWrite(LED_BUILTIN, LOW);
  delay(500);
  digitalWrite(LED_BUILTIN, HIGH);
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);
}

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
  digitalWrite(LED_BUILTIN, HIGH);
  Serial.begin(115200);

  if (!connectWifi()){
    configAccessPoint();
    setupAP();
  } else {
    setupFirebase();
  }
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
}

void loop() {
  if (isConnectionAvailable) {
    int temp =  hcsr04.distanceInMillimeters();
  
  //  30 --> 3000
  
    int distance = 0;
    if (temp > 30 && temp < 3000) {
        distance = temp;
    } else {
      Serial.println(temp);
      delay(500);
      temp =  hcsr04.distanceInMillimeters();
      if (temp > 30 && temp < 3000) {
        distance = temp;
      } else {
        Serial.println(temp);
        delay(500);
        temp =  hcsr04.distanceInMillimeters();
        if (temp > 30 && temp < 3000) {
          distance = temp;
        }
      }
    }

    String jsonStr = "{\"equipId\" : \"" + String(EQUIP_ID) + "\", \"data\" : " + String(distance) + "}";

    if (Firebase.updateNode(firebaseData, path, jsonStr))
    {
      Serial.println("----------Update result-----------");
      Serial.println("PATH: " + firebaseData.dataPath());
      Serial.println("TYPE: " + firebaseData.dataType());
      Serial.print("VALUE: ");
      if (firebaseData.dataType() == "int")
        Serial.println(firebaseData.intData());
      else if (firebaseData.dataType() == "float")
        Serial.println(firebaseData.floatData());
      else if (firebaseData.dataType() == "boolean")
        Serial.println(firebaseData.boolData() == 1 ? "true" : "false");
      else if (firebaseData.dataType() == "string")
        Serial.println(firebaseData.stringData());
      else if (firebaseData.dataType() == "json")
        Serial.println(firebaseData.jsonData());
      Serial.println("--------------------------------");
      Serial.println();
    }
    else
    {
      Serial.println("----------Can't Update data--------");
      Serial.println("REASON: " + firebaseData.errorReason());
      Serial.println("--------------------------------");
      Serial.println();
    }

    delay(60000);
    
    if (Firebase.getString(firebaseData, path)) {
      Serial.println("----------Get result-----------");
      Serial.println("PATH: " + firebaseData.dataPath());
      Serial.println("TYPE: " + firebaseData.dataType());
      Serial.print("VALUE: ");
      if (firebaseData.dataType() == "int")
        Serial.println(firebaseData.intData());
      else if (firebaseData.dataType() == "float")
        Serial.println(firebaseData.floatData());
      else if (firebaseData.dataType() == "boolean")
        Serial.println(firebaseData.boolData() == 1 ? "true" : "false");
      else if (firebaseData.dataType() == "string")
        Serial.println(firebaseData.stringData());
      else if (firebaseData.dataType() == "json")
        Serial.println(firebaseData.jsonData());
      Serial.println("--------------------------------");
      Serial.println();
    } else {
      Serial.println("----------Can't get data--------");
      Serial.println("REASON: " + firebaseData.errorReason());
      Serial.println("--------------------------------");
      Serial.println();
    }
  } else {
    serverAP.handleClient();
  }
}
