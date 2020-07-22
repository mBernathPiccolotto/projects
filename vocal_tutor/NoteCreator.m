%% Note Creator


function S = NoteCreator(n)

load('AudioParameters.mat');
load('Notes.mat');

pureSinT = 1/Fs;                        % Sampling Period
pureSigLen = 100000;                    % Length of signal
pureTimeT = (0:pureSigLen)*pureSinT;    % Time Vector
S = cos(2*pi*(note(n).frequency)*pureTimeT);