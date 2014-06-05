# daisy-basic.py
# Synthesize Daisy and write to .wav file

import numpy as N
import wave


class WavFile:
    def __init__(self, signal, samplerate):
        # open file in write-only mode
        self.file = wave.open('daisy.wav','wb')
        # pack signal to short int
        self.signal = ''
        for i in range(len(signal)):
            self.signal += wave.struct.pack('h',signal[i])
        self.sr = samplerate

    def write(self):
        # set file params and write signal to file
        self.file.setparams((1, 2, self.sr, len(self.signal), 'NONE', 'noncompressed'))
        self.file.writeframes(self.signal)
        self.file.close()
        print('.wav file written')

# given frequency in hertz, duration in seconds, and samplerate
def tone(frequency, duration, samplerate):
    t = N.arange(int(duration*samplerate),dtype=N.float)/samplerate
    t = N.sin(2*N.pi*frequency*t)*N.exp(-2/duration*t)
    return t

SAMPLERATE = 44100 # Samplerate in hertz
QUARTER = 0.180 # Quarter note length in seconds
A440 = 440 # Frequency constant
DAISY_P = [
        74, 71, 67, 62, 64, 66, 67, 64, 67, 62,
        69, 74, 71, 67, 64, 66, 67, 69, 71, 69,
        71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62,
        62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67
]
DAISY_T = [
        3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
        3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
        1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5,
        1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5
]
DAISY_P = N.array(DAISY_P)
DAISY_T = N.array(DAISY_T)*QUARTER

signal = N.array([0])
# loop through and build signal vector
for i in range(0,len(DAISY_P)):
    f = 2**((DAISY_P[i]-69)/12.0)*A440
    signal = N.append(signal,tone(f, DAISY_T[i], SAMPLERATE))

signal *= (2**15-1) # scale the signal

signal = N.resize(signal, (len(signal),))

f = WavFile(signal, SAMPLERATE)
f.write()

