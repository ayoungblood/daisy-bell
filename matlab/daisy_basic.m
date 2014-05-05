function daisy_basic()
% daisy_basic.m
% Simple MATLAB implementation of Daisy Bell
% Invoke with >> daisy_basic
    DAISY_P = [ ...
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
    DAISY_T = DAISY_T * QUARTER;
    signal = [];
    % loop through and concatenate to signal
    for i=1:length(DAISY_P)
        f = 2^((DAISY_P(i)-69)/12.0)*A440; % convert to hertz
        signal = [signal, tone(f,DAISY_T(i),SAMPLE_RATE)];
    end
    sound(signal,SAMPLE_RATE);
end

% Given frequency in hertz, duration in seconds, and samplerate,
% return a signal vector of the tone with exponential decay
function rv = tone(frequency, duration, samplerate)
    t = (0:samplerate*duration)/(samplerate-1);
    t = sin(2*pi*frequency*t).*exp(-2/duration*t);
    rv = t;
end

% CONSTANTS
function const = QUARTER
    const = 0.180;
end
function const = A440
    const = 440;
end
function const = SAMPLE_RATE
    const = 16384;
end
