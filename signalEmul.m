function [ samples ] = signalEmul( Fs, period, freq, amp)
% samples = signalEmul( Fs, period, freq, amp )
% Fs - Sampling frequency;
% period - Total period of sampling;
% freq - array (line) of desired frequencies;
% amp - array (line) of ampplitudes (peak) of frequencies given in freq array.

    if(length(freq) ~= length(amp))
       display('Error in signalEmul: length of freq ~= length of amp!');
       return;
    end
    
    t      	= 0:(1/Fs):(period - 1/Fs);
    samples	= zeros(size(t));

    for i = 1:length(freq)
        samples = samples + amp(i) * sin(2 * pi * freq(i) * t);
    end
end

