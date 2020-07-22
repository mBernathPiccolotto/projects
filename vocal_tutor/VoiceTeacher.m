%% Demo Feature: Can you match Frequency?

clear all
clc

%% Load Data

load('Notes.mat')
bits = 16;   %sample size
Fs = 65536;  %in Hz, sample rate   (important that this number is a power of 2)
T = 0.5;       %seconds (important that this number is a power of 2)
N = T/(1/Fs);


%% Creating a Random Note


n = randi(41);

S = NoteCreator(n);
 
%% Play Note and Record the Audio Signal

disp('Here is your note:');
sound(S, Fs);                                                   %Plays note
disp(['     Note Played: ', note(n).name]) 
disp(['     Frequency of note: ', num2str(note(n).frequency)]);
disp(' ');
pause(1);
disp('Ready to sing your note?');
disp(' ');
pause(1);
disp('Sing and hold out your note now:');
disp('Start of Recording.');
recObj = audiorecorder(Fs, bits, 1, -1);             
recordblocking(recObj, T);                                     % T stands for seconds
disp('End of Recording');


%% Analyze Sound and Display Frequency to User

makeplot = true;   % Displays or not the fft graph of recorded sound

sungFrequency = analyzer(recObj,makeplot);

disp(['You sang at a ',num2str(sungFrequency),' frequency']);