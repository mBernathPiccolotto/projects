%% Note Recorder and Analyser
 
function sungFrequency =  Live_analyzer(recObj,makeplot)
%% Get recording parameters
 
bits = 16;   %sample size
Fs = 2^17;  %in Hz, sample rate   (important that this number is a power of 2)
T = 1/(2^3);        %seconds (important that this number is a power of 2)
N = T/(1/Fs);
 
%% Create array for sound to analyze
 
soundArray = getaudiodata(recObj, 'int16');
X = double(soundArray);
 
%% Calculating the fourier transform
 
Y = mfft(X);
 
%% Plotting fourier transform
 
mag1 = abs(Y(1:N/2));
frequency = 0:1/T:(N/2-1)/T;
 
if makeplot
grid on
plot(frequency, mag1);
title('Single-Sided Amplitude Spectrum of X(t)')
magMax = max(mag1)+100;
axis([0 1000 0 magMax]);
xlabel('f (Hz)')
ylabel('|P1(f)|')
end
 
%% Finding the fundamental tone input by the user
 


maxVolume = 0;
for i = 1:8192
    if mag1(i) > maxVolume
        maxVolume = mag1(i);
        frequencyCol = i;
    end
end
 
sungFrequency = frequency(1, frequencyCol);
