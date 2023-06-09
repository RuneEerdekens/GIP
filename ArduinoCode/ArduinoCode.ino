#include <Servo.h>  //importeer de servo biblioteek voor het gemakelijk maken van PWM singaalen

const char SIZE = 5;

unsigned char In[SIZE];       // zet groote voor de input buffer, dus ik verwatch om 5 bytes per keer te ontvangen
unsigned char MotorSpeed[4];  // houd de totaale motor snelheid bij voor elke motor

unsigned char Trothle[4];  // algemeene trothle van de drone dus hoe snel ze draaien
unsigned char Dir1[4];     //dir 1 is for forward back left and right, houd bij hoeveel elke motor bij krijgt als er in een bepaalde richting bewogen word

Servo ESC1;
Servo ESC2;
Servo ESC3;
Servo ESC4;  //initializeer alle ESC's (Electronic Speed Controller's)

int i = 0;  //iterator

void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);  // initializeer hardware en software Serieele comunicaties

  ESC1.attach(3, 700, 2300);
  ESC2.attach(5, 700, 2300);
  ESC3.attach(6, 700, 2300);
  ESC4.attach(9, 700, 2300);  // assing pinnummer, min pulsgrote voor pwm, max pulsegroote voor pwm

  for (int speed = 0; speed < 180; speed++) {
    ESC1.write(speed);
    ESC2.write(speed);
    ESC3.write(speed);
    ESC4.write(speed);
    delay(10);
  }
  delay(1000);
  ESC1.write(0);
  ESC2.write(0);
  ESC3.write(0);
  ESC4.write(0);
}

void loop() {
  if (Serial1.available() > 0) {
    int len = Serial1.readBytes(In, SIZE);  //lees "SIZE" (SIZE = 5) bytes per keer en sla ze op in de "In" lijst
    if (In[0] == 0xF2) {                    // 1ste byte is signal byte die aantoont welke soort data het is
      for (i = 1; i < 5; i++) {
        Trothle[i - 1] = In[i];  // in dit geval is het de trothel data dus set de trothel lijst naar de nieuwe waarden
      }
    }

    if (In[0] == 0xF0) {  // zelfde als hierboven dit is True als de signal byte gelijk is aan 0xF0 of 240
      for (i = 1; i < 5; i++) {
        Dir1[i - 1] = In[i];  // zet de Dir1 lijst gelijk aan de nieuwe waarden
      }
    }

    for (int j = 0; j < 4; j++) {  //voor elke motor word de totaal snelheid gelijkgezet aan de Trothle + Dir
      MotorSpeed[j] = Trothle[j] + Dir1[j];
      Serial.print(j);  //prints voor debugig
      Serial.print(": ");
      Serial.println(MotorSpeed[j], DEC);
    }
    ESC1.write(MotorSpeed[0]);
    ESC2.write(MotorSpeed[1]);
    ESC3.write(MotorSpeed[2]);
    ESC4.write(MotorSpeed[3]);  // schrijf alle motorsnelheeden naar de ESC's min waarde is 0 en max is 180
    // dus de motors draaien op 100% snelheid als motorspeed voor die motor gelijk is aan 180
  }
}
