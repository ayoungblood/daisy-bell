# daisy_basic.rb
# Synthesize Daisy using a Ruby script
# Build a WAV file from scratch with basic file IO

SAMPLERATE = 44100 # Samplerate in hertz
QUARTER    = 0.180 # Quarter note length in seconds
A440       = 440   # Frequency constant

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

# get audio length in seconds and samples, and display
nSeconds = 0.0
DAISY_T.each do |time|
    nSeconds += time*QUARTER
end
NumSamples = nSeconds.ceil()*SAMPLERATE
puts "Length: " + ("%.2f" % nSeconds) + "s; samples: " + NumSamples.to_s
# create the signal vector
signal = []
signalIndex = 0
(0..DAISY_T.length-1).each do |i|
    noteSamples = (DAISY_T[i]*QUARTER*SAMPLERATE).ceil()
    note = []
    freq = 2**((DAISY_P[i]-69)/12.0)*A440
    (0..noteSamples-1).each do |j|
        note[j] = (32768*Math.sin(2*Math::PI*freq*(Float(j)/SAMPLERATE))).floor()
        note[j] *= Math::E**((-2.0/(DAISY_T[i]*QUARTER)*(Float(j)/SAMPLERATE)))
    end
    signal[signalIndex..signalIndex+note.length-1] = note
    signalIndex += noteSamples-1
end
# header constants                                     # type/width
ChunkID       = ['R','I','F','F']                      # u8[4]
Format        = ['W','A','V','E']                      # u8[4]
Subchunk1ID   = ['f','m','t',' ']                      # u8[4]
Subchunk2ID   = ['d','a','t','a']                      # u8[4]
AudioFormat   = 1                                      # u16
NumChannels   = 1                                      # u16
BitsPerSample = 16                                     # u16
BlockAlign    = NumChannels*BitsPerSample/8            # u16
Subchunk2Size = NumSamples*NumChannels*BitsPerSample/8 # u32
Subchunk1Size = 16                                     # u32
ChunkSize     = 4+(8+Subchunk1Size)+(8+Subchunk2Size)  # u32
SampleRate    = SAMPLERATE                             # u32
ByteRate      = SampleRate*NumChannels*BitsPerSample/8 # u32
# file write wrappers for writing fixed-width binary
def write8a(f,x) # write an array of bytes/chars
    (0..x.length).each do |i|
        f.write(x[i])
    end
end
def write16(f,x) # write a single 2 byte value
    b0 = (x%256).chr(); x=(x-x%256)/256
    b1 = (x%256).chr()
    f.write(b0); f.write(b1)
end
def write32(f,x) # write a single 4 byte value
    b0 = (x%256).chr(); x=(x-x%256)/256
    b1 = (x%256).chr(); x=(x-x%256)/256
    b2 = (x%256).chr(); x=(x-x%256)/256
    b3 = (x%256).chr()
    f.write(b0); f.write(b1); f.write(b2); f.write(b3)
end
# open file and write header
handle = File.open("daisy.wav","wb")
write8a(handle,ChunkID)
write32(handle,ChunkSize)
write8a(handle,Format)
write8a(handle,Subchunk1ID)
write32(handle,Subchunk1Size)
write16(handle,AudioFormat)
write16(handle,NumChannels)
write32(handle,SampleRate)
write32(handle,ByteRate)
write16(handle,BlockAlign)
write16(handle,BitsPerSample)
write8a(handle,Subchunk2ID)
write32(handle,Subchunk2Size)
# write signal data
(0..signal.length-1).each do |i|
    write16(handle,signal[i].floor())
end
# close file
handle.close()
puts "Audio successfully written to daisy.wav"
