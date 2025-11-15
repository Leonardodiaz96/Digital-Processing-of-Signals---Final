int out=0;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  
}

void loop() {
  // put your main code here, to run repeatedly:
  out=analogRead(A0);
  Serial.print(out);
  Serial.print("\n");
  //delayMicrosecond(10);
}
