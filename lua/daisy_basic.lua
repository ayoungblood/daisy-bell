--[[
  daisy_basic.lua
  Synthesize Daisy using a Lua script
  Build a WAV file from scratch with basic file IO
]]--

SAMPLERATE = 44100 -- Samplerate in hertz
QUARTER    = 0.180 -- Quarter note length in seconds
A440       = 440   -- Frequency constant

DAISY_P = {
    74, 71, 67, 62, 64, 66, 67, 64, 67, 62,
    69, 74, 71, 67, 64, 66, 67, 69, 71, 69,
    71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62,
    62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67
}
DAISY_T = {
    3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
    3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
    1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5,
    1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5
}

-- get the length of the audio in seconds
nSeconds = 0.0
for i = 1, #DAISY_T do
    nSeconds = nSeconds + DAISY_T[i]*QUARTER
end
-- get the length of the signal vector
NumSamples = math.ceil(nSeconds)*SAMPLERATE
print(numSamples)
-- create and initialize the signal vector
signal = {}
for i = 1, NumSamples do
    signal[i] = 0.0
end
print("Length: " .. tostring(nSeconds) .. "s; samples: " .. tostring(NumSamples))
-- create the signal by building from note vectors
signalIndex = 1
for i = 1, #DAISY_T do
    noteSamples = math.ceil(DAISY_T[i]*QUARTER*SAMPLERATE)
    note = {}
    freq = math.pow(2,(DAISY_P[i]-69)/12.0)*A440
    for j = 1, noteSamples do
        note[j] = math.floor(32768*math.sin(2*math.pi*freq*(j/SAMPLERATE)))
        note[j] = note[j]*math.pow(math.exp(1),-2.0/(DAISY_T[i]*QUARTER)*(j/SAMPLERATE))
    end
    -- copy note vector into signal vector
    for k = 1, noteSamples do
        signal[signalIndex+k] = note[k]
    end
    signalIndex = signalIndex + noteSamples
end
-- write file
-- header constants                                    -- type
ChunkID       = {'R','I','F','F'}                      -- u8[4]
Format        = {'W','A','V','E'}                      -- u8[4]
Subchunk1ID   = {'f','m','t',' '}                      -- u8[4]
Subchunk2ID   = {'d','a','t','a'}                      -- u8[4]
AudioFormat   = 1                                      -- u16
NumChannels   = 1                                      -- u16
BitsPerSample = 16                                     -- u16
BlockAlign    = NumChannels*BitsPerSample/8            -- u16
Subchunk2Size = NumSamples*NumChannels*BitsPerSample/8 -- u32
Subchunk1Size = 16                                     -- u32
ChunkSize     = 4+(8+Subchunk1Size)+(8+Subchunk2Size)  -- u32
SampleRate    = SAMPLERATE                             -- u32
ByteRate      = SampleRate*NumChannels*BitsPerSample/8 -- u32
-- file write wrappers
-- for writing fixed-width binary
function writeu8a(f,x) -- write an array of bytes/chars
    for i = 1, #x do
        f:write(x[i])
    end
end
function writeu16(f,x) -- write a single 2 byte value
    local b0 = string.char(x%256) x=(x-x%256)/256
    local b1 = string.char(x%256)
    f:write(b0,b1) -- check endianness
end
function writeu32(f,x) -- write a single 4 byte value
    local b0 = string.char(x%256) x=(x-x%256)/256
    local b1 = string.char(x%256) x=(x-x%256)/256
    local b2 = string.char(x%256) x=(x-x%256)/256
    local b3 = string.char(x%256)
    f:write(b0,b1,b2,b3) -- check endianness
end
-- open file and write header
handle = io.open("daisy.wav","wb")
writeu8a(handle,ChunkID)
writeu32(handle,ChunkSize)
writeu8a(handle,Format)
writeu8a(handle,Subchunk1ID)
writeu32(handle,Subchunk1Size)
writeu16(handle,AudioFormat)
writeu16(handle,NumChannels)
writeu32(handle,SampleRate)
writeu32(handle,ByteRate)
writeu16(handle,BlockAlign)
writeu16(handle,BitsPerSample)
writeu8a(handle,Subchunk2ID)
writeu32(handle,Subchunk2Size)
-- write signal data
for i = 1, #signal do
    writeu16(handle,math.floor(signal[i]))
end

-- close file
handle:close()
print("Audio successfully written to daisy.wav")
