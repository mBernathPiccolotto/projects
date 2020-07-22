function [] = LIVE_FFT()

%% Live FFT

clear all
clc

%% Inputs


% Set Parameters for audio recording process
bits = 16;   %sample size
Fs = 2^17;  %in Hz, sample rate   (important that this number is a power of 2)
T = 1/(2^3);       %seconds (important that this number is a power of 2)
N = T/(1/Fs);


%% Compute

time = input('How long would you like the graph to run in seconds? ');


for i = 1:time*1.5


    
recObj = audiorecorder(Fs, bits, 1, -1);
recordblocking(recObj, T);


%% Analyze Sound and Display Frequency to User

makeplot = true;   % Displays or not the fft graph of recorded sound
sungFrequency = Live_analyzer(recObj,makeplot);


end