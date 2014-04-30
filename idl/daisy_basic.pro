; daisy_basic.pro
; Simple IDL implementation of Daisy Bell
; Result is a .wav file in the current directory

pro daisy_basic
  compile_opt idl2
  
  CONSTANTS = { $
    SAMPLERATE: 16384, $ ; sample rate, in hertz
    A440: 440, $ ; tuning of middle A, in hertz
    QUARTER: 0.180 $ ; duration of a quarter note in seconds
  }
  ; pitch and time data
  DAISY_P = [ $
    74, 71, 67, 62, 64, 66, 67, 64, 67, 62, $
    69, 74, 71, 67, 64, 66, 67, 69, 71, 69, $
    71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62, $
    62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67 $
  ]
  DAISY_T = [ $
    3,  3,  3,  3,  1,  1,  1,  2,  1,  6, $
    3,  3,  3,  3,  1,  1,  1,  2,  1,  6, $
    1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5, $
    1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5 $
  ]
  DAISY_T *= CONSTANTS.QUARTER ; convert time to seconds
  
  ; loop through notes, concatenating to signal
  signal = 0
  for i=0,(size(DAISY_P,/DIMENSIONS))[0]-1 do begin
    f = 2^((DAISY_P[i]-69)/12.0)*CONSTANTS.A440 ; convert MIDI to hertz
    signal = [signal, tone(f,DAISY_T[i],CONSTANTS.SAMPLERATE)]
  endfor
  signal *= 2^15
  
  ; write the data to a .wav file
  WRITE_WAV, 'daisy.wav', signal, CONSTANTS.SAMPLERATE
  
end

; given frequency in hertz, duration in seconds, and samplerate,
; return a signal vector with exponential decay
function tone, frequency, duration, samplerate
  t = findgen(duration*samplerate)/(samplerate-1)
  t = sin(2*!CONST.PI*frequency*t)*exp(-2/duration*t)
  return, t
end

