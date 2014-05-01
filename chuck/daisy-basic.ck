// daisy-basic.ck
// Simple ChucK implementation of Daisy Bell

// pitch and time data
[74, 71, 67, 62, 64, 66, 67, 64, 67, 62,
 69, 74, 71, 67, 64, 66, 67, 69, 71, 69,
 71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62,
 62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67] @=> int DAISY_P[];

[ 3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
  3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
  1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5,
  1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5] @=> int DAISY_T[];

0.180 => float QUARTER; // quarter note length, in seconds

SinOsc osc => Envelope env => dac; // define signal chain

// loop through and play notes
0 => int i;
while (i<DAISY_P.size()){
    Std.mtof(DAISY_P[i]) => osc.freq; // set frequency
    
    5::ms => dur d => env.duration; // attack
    1.0 => env.target;
    5::ms => now;
    
    DAISY_T[i]*QUARTER => float t; // release
    t => env.time;
    0.0 => env.target;
    t::second => now;
    
    ++i;
}

