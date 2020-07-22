function [frequencyError, centsError, maxFrequencySung, minFrequencySung] = pitchError(sungFrequency, n)
% Lauren Rymsza
% April 16th, 2019
% This function finds the error in a person's sung note, whether sharp or
% flat in hertz and in cents. This also calculates the bounds within which
% a sung note is considered correct. 
load('Notes.mat');
frequencyError = sungFrequency-note(n).frequency; 
centsError = 1200*log2(sungFrequency/note(n).frequency);
maxFrequencySung = 2^(12.5/1200)*note(n).frequency;
minFrequencySung = 2^(-12.5/1200)*note(n).frequency;

