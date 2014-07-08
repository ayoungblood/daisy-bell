# daisy_basic.r
# Simple R implementation of Daisy Bell
# Uses audio package, and plays entire signal

require("audio")
DAISY_P <- c( 74, 71, 67, 62, 64, 66, 67, 64, 67, 62,
          69, 74, 71, 67, 64, 66, 67, 69, 71, 69,
          71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62,
          62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67)
DAISY_T <- c(  3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
           3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
           1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5,
           1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5)
QUARTER    <- 0.180
A440       <- 440
SAMPLERATE <- 44100
DAISY_T = DAISY_T * QUARTER

signal <- numeric()
for (i in 1:length(DAISY_P)) {
	t <- 0:(SAMPLERATE*DAISY_T[i])/(SAMPLERATE-1)
	f <- 2^((DAISY_P[i]-69)/12)*A440
	t <- sin(2*pi*f*t) * exp(-2/DAISY_T[i]*t)
	signal = c(signal, t)
}
play(signal,rate=SAMPLERATE)
