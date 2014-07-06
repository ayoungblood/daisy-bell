/**
 * daisy_basic.c
 * Synthesize Daisy using barebones C
 * Using basic file I/O for writing
 * .wav files use a very straightforward binary format
 * Compile and run with
 *     gcc daisy_basic.c && ./a.out
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <string.h>

#define SAMPLERATE 44100 // Samplerate in hertz
#define QUARTER 0.180f // Quarter note length in seconds
#define A440 440 // Frequency constant

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

int main(void) {
    uint32_t i,j;
    // get the length of the audio in seconds
    double nSeconds = 0.0;
    for (i=0;i<sizeof(DAISY_T);++i) {
        nSeconds += DAISY_T[i]*QUARTER;
    }
    // get the length of the signal vector
    uint32_t NumSamples = (uint32_t)ceil(nSeconds)*SAMPLERATE;
    // create and initialize the signal vector
    int16_t signal[NumSamples];
    for (i=0;i<NumSamples;++i) {
        signal[i] = 0;
    }
    printf("Length: %.2fs; samples: %i\n",nSeconds,NumSamples);
    // create the signal by building from note vectors
    uint32_t noteSamples, noteIndex=0;
    for (i=0;i<sizeof(DAISY_T);++i) {
        noteSamples = (uint32_t)ceil(((double)DAISY_T[i])*QUARTER*SAMPLERATE);
        int16_t note[noteSamples];
        float freq = pow(2,(DAISY_P[i]-69)/12.0f)*A440;
        for (j=0;j<noteSamples;++j) {
            note[j] = (int16_t)floor(32768*sin(2*M_PI*freq*(((float)j)/SAMPLERATE)));
            note[j] = (int16_t)(note[j]*pow(M_E,-2.0f/(DAISY_T[i]*QUARTER)*(j/((double)SAMPLERATE))));
        }
        memcpy(signal+noteIndex,note,noteSamples*sizeof(int16_t));
        noteIndex += noteSamples-1;
    }
    // file pointer and bytes written counter
    size_t bw = 0;
    FILE *fileptr;
    // header constants
    uint8_t  ChunkID[4]     = {'R','I','F','F'},
             Format[4]      = {'W','A','V','E'},
             Subchunk1ID[4] = {'f','m','t',' '},
             Subchunk2ID[4] = {'d','a','t','a'};
    uint16_t AudioFormat    = 1,
             NumChannels    = 1,
             BitsPerSample  = 16,
             BlockAlign     = NumChannels * BitsPerSample/8;
    uint32_t Subchunk2Size  = NumSamples * NumChannels * BitsPerSample/8,
             Subchunk1Size  = 16,
             ChunkSize      = 4 + (8 + Subchunk1Size) + (8 + Subchunk2Size),
             SampleRate     = 44100,
             ByteRate       = SampleRate * NumChannels * BitsPerSample/8;
    // open file
    fileptr = fopen("daisy.wav","wb");
    // write header
    bw += fwrite(ChunkID, sizeof(uint8_t), sizeof(ChunkID), fileptr);
    bw += fwrite(&ChunkSize, sizeof(uint32_t), 1, fileptr);
    bw += fwrite(Format, sizeof(uint8_t), sizeof(Format), fileptr);
    bw += fwrite(Subchunk1ID, sizeof(uint8_t), sizeof(Subchunk1ID), fileptr);
    bw += fwrite(&Subchunk1Size, sizeof(uint32_t), 1, fileptr);
    bw += fwrite(&AudioFormat, sizeof(uint16_t), 1, fileptr);
    bw += fwrite(&NumChannels, sizeof(uint16_t), 1, fileptr);
    bw += fwrite(&SampleRate, sizeof(uint32_t), 1, fileptr);
    bw += fwrite(&ByteRate, sizeof(uint32_t), 1, fileptr);
    bw += fwrite(&BlockAlign, sizeof(uint16_t), 1, fileptr);
    bw += fwrite(&BitsPerSample, sizeof(uint16_t), 1, fileptr);
    bw += fwrite(Subchunk2ID, sizeof(uint8_t), sizeof(Subchunk2ID), fileptr);
    bw += fwrite(&Subchunk2Size, sizeof(uint32_t), 1, fileptr);
    // write data
    bw += fwrite(signal, sizeof(int16_t), NumSamples, fileptr);
    // check for successful write
    if (bw != ChunkSize - 8 && ferror(fileptr)) {
        perror("fwrite()");
        fprintf(stdout,"fwrite() failed in file %s at line # %d\n",
                __FILE__,__LINE__-5);
        exit(EXIT_FAILURE);
    }
    fclose(fileptr);
    printf("Audio successfully written to daisy.wav\n");
    return 0;
}
