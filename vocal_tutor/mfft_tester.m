%% About this code

% mfft tester

% Marcelo Bernath Piccolotto
% April 24th


%% Inputs

load('AudioParameters');
load('Notes');


recObj = audiorecorder(Fs, bits, 1, -1);             
recordblocking(recObj, T);   


%% Create array for sound to analyze
 
soundArray = getaudiodata(recObj, 'int16');
X = double(soundArray);
 
%% Calculating the fourier transform using mfft
 
Y = mfft(X);

%% Plotting fourier transform
 
mag1 = abs(Y(1:N/2));
frequency = 0:1/T:(N/2-1)/T;
 

grid on
plot(frequency, mag1);
title('Single-Sided Amplitude Spectrum of X(t) using mfft')
magMax = max(mag1)+100;
axis([0 1000 0 magMax]);
xlabel('f (Hz)')
ylabel('|P1(f)|')

 
%% Calculating the fourier transform using fft
 
Y = fft(X);


%% Plotting fourier transform
 
mag1 = abs(Y(1:N/2));
frequency = 0:1/T:(N/2-1)/T;
 

figure
grid on
plot(frequency, mag1);
title('Single-Sided Amplitude Spectrum of X(t) using fft')
magMax = max(mag1)+100;
axis([0 1000 0 magMax]);
xlabel('f (Hz)')
ylabel('|P1(f)|')





