%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc
% Data constants
true    = 1;
false   = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sampling frequency (hertz)
Fs                  = 900;  
% Sampling period (seconds)
period              = 1; 
% Frequency of interest (hertz)
Fi                  = 60;  
% Window function
windowFcn           = 'kaiser';
% Center lob compensation
compensateCenterLob	= true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulated signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freq        = [30, 53, 60, 110, 120, 167, 180, 240];
amp         = [0.5, 1,  3, 0.8, 0.2, 0.1, 0.3, 0.1];
samples     = signalEmul(Fs, period, freq, amp);

subplot(2,2,1);
plot(samples);
xlim([0 length(samples)])
title('Sampled Signal');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Real (exact) thd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In "Adaptive PWM Algorithm Using Digital-Signal Processing based THD 
% Measurement for Electric Vehicle Application", %THD is defined by the
% 100 * sqrt(V1^2 + V2^2 +vV3^2 + ... - V1^2) / V1, i.e,
% THDf = sqrt(V2^2 + V3^2 + V4^2 ... )/V1; where Vn is the peak-to-peak 
% voltage of nth armonic frequency.
% Calculation also from paper: Simplified THD Measurement and Analysis for 
% Electronic Power Inverters - K. Sajjad, G. Kalsoom and A. Mughal (2015)
% and references on:
% https://www.mathworks.com/help/signal/ref/thd.html?requestedDomain=true
hamronicSqr = 0;
fiAmp       = 0;
harmonics   = 1;
for i = 1:length(freq)
   % If there is no quotient, so the freq(i) is an harmonic of Fi
   if mod(freq(i), Fi) == 0
       if freq(i) == Fi
           fiAmp = amp(i);
       else
           % Sum the square of harmonic ampplitude
           hamronicSqr  = hamronicSqr + amp(i)^2;
           harmonics    = harmonics + 1;
       end
   end
end
exact_thd = 100 * sqrt((hamronicSqr) / fiAmp^2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab thd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
result      = thd(samples,harmonics);
subplot(1,2,2);
thd(samples, Fs, harmonics);
title('Matlab thd Result');
matlab_thd  = 100*(10^(result/20))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Proposed thd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
samples     = applyWindow(samples, windowFcn, false);

subplot(2,2,3);
plot(samples);
xlim([0 length(samples)])
title('Signal After Windowing');

zeroPadding = zeroPadding4fft(Fs, Fi, length(samples));

fftResult   = abs(fft(samples, zeroPadding));
fftResult   = fftResult / length(samples);

% Linear compensation of center lob
% Doesn't affect the percentual THD result. This is done just for exactly 
% representation of amplitudes of the harmonics.
if(compensateCenterLob == true)
maxRectang  = max(abs(fft(ones(1, length(samples)))));
maxWindow   = max(abs(fft(applyWindow(ones(1, length(samples)), ...
                                                      windowFcn, false))));   
fftResult   = fftResult * 2 * (maxRectang / maxWindow);  
end

% Set the frequency axis to nyquist, excluding reflected signals
freqAxis    = 0:((Fs/2) / (zeroPadding / 2)):Fs/2;
fftResult   = fftResult(1:length(freqAxis));
res         = Fs / zeroPadding; 
harmonics   = fftResult(Fi/res + 1:Fi/res:round(zeroPadding/2)) * 2;
sumOfHarm   = 0;
for i = 2:length(harmonics)
    sumOfHarm = sumOfHarm + harmonics(i)^2;
end
proposed_thd = 100 * sqrt(sumOfHarm) / harmonics(1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extra results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(compensateCenterLob == true)
    disp('The estimated amplitude (peak to peak) of each harmonic is:')
    disp(harmonics)
end






