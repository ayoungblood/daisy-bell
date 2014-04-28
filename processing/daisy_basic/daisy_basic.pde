/**
 * daisy_basic.pde
 * Synthesize Daisy using Minim
 * Using draw loop for timing
 */

import ddf.minim.*;
import ddf.minim.ugens.*;

// quarter note duration in ms
static final int QUARTER = 180;
// Daisy pitch data
static final int DAISY_P[] = {
      74, 71, 67, 62, 64, 66, 67, 64, 67, 62,
      69, 74, 71, 67, 64, 66, 67, 69, 71, 69,
      71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62,
      62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67};
// Daisy note length data
static final int DAISY_T[] = {
       3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
       3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
       1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5,
       1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5};

Minim minim;
AudioOutput out;
Oscil osc;

int targetFrame = 1; // framenumber of the frame we care about
int index = 0; // keep track of note index

void setup(){
  size(128,128);
  frameRate(1/(QUARTER/1000.0f));
  minim = new Minim(this);
  out = minim.getLineOut(); // get an audio output
  osc = new Oscil(0, 0.5f, Waves.SINE); // get a sine oscillator
  osc.patch(out);
}

void draw(){
  background(0);
  if (targetFrame == frameCount){
    osc.setFrequency(pow(2,(DAISY_P[index]-69)/12.0f)*440);
    println("Playing note: " + DAISY_P[index]);
    targetFrame += DAISY_T[index]; // to get proper durations
    index = (++index)%DAISY_P.length; // repeat forever
  }
}
