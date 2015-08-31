# daisy_basic.pl
# Synthesize Daisy using Perl
# Build a WAV file from scratch with basic file IO

use POSIX; # for floor/ceil
use Math::Trig; # for pi

my $SAMPLERATE = 44100; # Samplerate in hertz
my $QUARTER    = 0.180; # Quarter note length in seconds
my $A440       = 440;   # Frequency constant

my @DAISY_P = (
    74, 71, 67, 62, 64, 66, 67, 64, 67, 62,
    69, 74, 71, 67, 64, 66, 67, 69, 71, 69,
    71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62,
    62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67
);
my @DAISY_T = (
    3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
    3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
    1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5,
    1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5
);

# get audio length in seconds and samples, print
my $nSeconds = 0.0;
for my $time (@DAISY_T) {
    $nSeconds += $time*$QUARTER;
}
my $NumSamples = ceil($nSeconds) * $SAMPLERATE;
print "Length: $nSeconds s; samples: $NumSamples\n";
# create the signal vector
my @signal = ();
my $signalIndex = 0;
for (my $i = 0; $i < @DAISY_T; $i++) {
    my $noteSamples = ceil(@DAISY_T[$i]*$QUARTER*$SAMPLERATE);
    my $note = ();
    my $freq = 2**((@DAISY_P[$i]-69)/12.0)*$A440;
    # print "$freq\n";
    for (my $j = 0; $j < $noteSamples; $j++) {
        $note[$j] = floor(32768*sin(2*pi*$freq*($j/$SAMPLERATE)));
        $note[$j] *= exp(1)**(-2.0/(@DAISY_T[$i]*$QUARTER)*($j/$SAMPLERATE));
    }
    # copy note vector into signal vector
    for (my $k = 1; $k <= $noteSamples; $k++) {
        @signal[$signalIndex+$k] = @note[$k];
    }
    $signalIndex += $noteSamples-1;
}
#print $#signal;
# write WAV file
# WAV header constants
my @ChunkID       = ('R','I','F','F');
my @Format        = ('W','A','V','E');
my @Subchunk1ID   = ('f','m','t',' ');
my @Subchunk2ID   = ('d','a','t','a');
my $AudioFormat   = 1;
my $NumChannels   = 1;
my $BitsPerSample = 16;
my $BlockAlign    = $NumChannels*$BitsPerSample/8;
my $Subchunk2Size = $NumSamples*$NumChannels*$BitsPerSample/8;
my $Subchunk1Size = 16;
my $ChunkSize     = 4+(8+$Subchunk1Size)+(8+$Subchunk2Size);
my $SampleRate    = $SAMPLERATE;
my $ByteRate      = $SampleRate*$NumChannels*$BitsPerSample/8;
# file write wrappers, for writing fixed-width binary
sub writeu8a { # write an array of bytes
    my ($f,@x) = @_;
    for (my $i = 0; $i < @x; $i++) {
        print $f pack('c',ord(@x[$i]));
    }
}
sub writeu16 { # write a single 2 byte value
    my ($f,$x) = @_;
    print $f pack('v',$x);
}
sub writeu32 { # write a single 4 byte value
    my ($f,$x) = @_;
    print $f pack('V',$x);
}
open(my $handle, '>:raw', 'daisy.wav') or die "Failed to open: $!";
writeu8a($handle,@ChunkID);
writeu32($handle,$ChunkSize);
writeu8a($handle,@Format);
writeu8a($handle,@Subchunk1ID);
writeu32($handle,$Subchunk1Size);
writeu16($handle,$AudioFormat);
writeu16($handle,$NumChannels);
writeu32($handle,$SampleRate);
writeu32($handle,$ByteRate);
writeu16($handle,$BlockAlign);
writeu16($handle,$BitsPerSample);
writeu8a($handle,@Subchunk2ID);
writeu32($handle,$Subchunk2Size);
# write signal data
for (my $i = 0; $i < @signal; $i++) {
    writeu16($handle,floor(@signal[$i]));
}

# close file
close($handle);
print "Audio succesfully written to daisy.wav\n";
