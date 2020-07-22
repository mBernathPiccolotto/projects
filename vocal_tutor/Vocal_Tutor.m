%% About this code

% Vocal tutor

% Lets user decide what feature they want to use.


%% Input

clear all
clc

disp('Which feature do you want to use?');
disp(' ');
disp('Enter 1 for Determine Voice Type');
disp('Enter 2 for Vocal Type Practice');
disp('Enter 3 for singing competition game');
disp('Enter 4 for Live FFT');
disp('Enter 5 for DEMO');

feature = input('');


%% Choose feature

if feature == 1
    Vocal_Determination;
elseif feature == 2
    Vocal_type_practice;
elseif feature == 3
    Competition;
elseif feature == 4
    LIVE_FFT
elseif feature == 5
    Demo;
end