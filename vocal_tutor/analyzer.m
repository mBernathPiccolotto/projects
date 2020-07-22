%% Note Recorder and Analyser
 
function sungFrequency =  analyzer(recObj,makeplot)
%% Get recording parameters
 
load('AudioParameters.mat');
 
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
for i = 1:20001
    if mag1(i) > maxVolume
        maxVolume = mag1(i);
        frequencyCol = i;
    end
end
 
sungFrequency = frequency(1, frequencyCol);
 



