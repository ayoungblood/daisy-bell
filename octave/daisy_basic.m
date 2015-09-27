#! /usr/local/bin/octave -qf
# daisy_basic.m
# Synthesize Daisy using octave. Similar to the MATLAB version
# If the octave executavble lives at /usr/local/bin/octave,
# this script can be run with
#   ./daisy_basic.m
# Otherwise, it can be run with
#   octave daisy_basic.m

SAMPLERATE = 44100; # Samplerate in hertz
QUARTER    = 0.180; # Quarter note length in seconds
A440       = 440;   # Frequency constant

DAISY_P = [
    74, 71, 67, 62, 64, 66, 67, 64, 67, 62, ...
    69, 74, 71, 67, 64, 66, 67, 69, 71, 69, ...
    71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62, ...
    62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67 ...
];
DAISY_T = [ ...
    3,  3,  3,  3,  1,  1,  1,  2,  1,  6, ...
    3,  3,  3,  3,  1,  1,  1,  2,  1,  6, ...
    1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5, ...
    1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5 ...
];

# Given a frequency in hertz, duration in seconds, and samplerate,
# return a signal vector of the tone with exponential decay
function rv = tone(frequency, duration, samplerate)
    t = (0:samplerate*duration)/(samplerate-1);
    t = sin(2*pi*frequency*t).*exp(-2/duration*t);
    rv = t;
end

DAISY_T *= QUARTER;
signal = [];
# loop through and concatenate signal
for i=1:length(DAISY_P)
    f = 2^((DAISY_P(i)-69)/12.0)*A440;
    signal = [signal, tone(f,DAISY_T(i),SAMPLERATE)];
end
NumSamples = length(signal);
# convert from [-1,1] to 16bit signed int
signal = int16(signal*32768);
# playing audio or writing audio files has spotty platform support
# write the audio as a WAV file
# WAV header parameters
ChunkID = "RIFF";
Format = "WAVE";
Subchunk1ID = "fmt ";
Subchunk2ID = "data";
AudioFormat = 1;
NumChannels = 1;
BitsPerSample = 16;
BlockAlign = NumChannels * BitsPerSample/8;
Subchunk1Size = 16;
Subchunk2Size = NumSamples * NumChannels * BitsPerSample/8;
ChunkSize = 4 + (8 + Subchunk1Size + (8 + Subchunk2Size));
SampleRate = SAMPLERATE;
ByteRate = SampleRate * NumChannels * BitsPerSample;
# open file
fid = fopen("daisy.wav","w");
# write header
fwrite(fid,ChunkID,"int8");
fwrite(fid,ChunkSize,"int32");
fwrite(fid,Format,"int8");
fwrite(fid,Subchunk1ID,"int8");
fwrite(fid,Subchunk1Size,"int32");
fwrite(fid,AudioFormat,"int16");
fwrite(fid,NumChannels,"int16");
fwrite(fid,SampleRate,"int32");
fwrite(fid,ByteRate,"int32");
fwrite(fid,BlockAlign,"int16");
fwrite(fid,BitsPerSample,"int16");
fwrite(fid,Subchunk2ID,"int8");
fwrite(fid,Subchunk2Size,"int32");
# write data
fwrite(fid,signal,"int16");
# close file
fclose(fid);
disp("Audio successfully written to daisy.wav");
