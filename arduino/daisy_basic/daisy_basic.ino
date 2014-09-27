/**
 * daisy_basic.ino
 * Play Daisy using built-in tone() function
 * 
 */

#define A440 440 // frequency constant
#define QUARTER 180 // quarter note length in ms

const uint8_t DAISY_P[] = {
        74, 71, 67, 62, 64, 66, 67, 64, 67, 62,
        69, 74, 71, 67, 64, 66, 67, 69, 71, 69,
        71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62,
        62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67
};
const uint8_t DAISY_T[] = {
        3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
        3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
        1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5,
        1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5
};

int i;

void setup() {
  //
}

void loop() {
  for (i=0; i<50; ++i) {
    float freq = pow(2,(DAISY_P[i]-69)/12.0f)*A440;
    tone(9,(int)freq,DAISY_T[i]*QUARTER);
    delay(DAISY_T[i]*QUARTER);
  }
  delay(QUARTER);
}

