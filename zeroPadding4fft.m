function [ zeroPadding ] = zeroPadding4fft(Fs, Fi, bufferLength)
% zeroPadding = zeroPadding4fft(Fs, bufferLength)
% Calculates the zero-padding for exactly frequency match on fft.
% The fft resolution is given by sampling frequency divided by samples
% length. To achive an exactly frequency match, is necessary to calculate
% the zero-padding, in this case the total length after zero-padding, in
% order to have a zero quotient (mod) of mainFrequency (frequency of
% interest) by the fft resolution.

    resolution  = Fs / bufferLength;
    zeroPadding = bufferLength;
    while mod(Fi, resolution) > 0
        zeroPadding = zeroPadding + 1;
        resolution  = Fs / zeroPadding;
    end
end

