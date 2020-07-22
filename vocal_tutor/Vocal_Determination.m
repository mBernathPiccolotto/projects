function [] = Vocal_Determination()

%% Feature 1: Determining Voice Type

clear all
clc

%% Load Data
 
load('Notes.mat')
load('AudioParameters.mat');
 
%% Creating a Random or Ordered Note

noteNum = 0;
basscounter = 0;
tenorcounter = 0;
altocounter = 0;
sopranocounter = 0;

for num = 1:41
    nArray(1, num) = num;
end
k = 1;

mode = ' ';
disp('Do you want to practice with randomized or ordered notes?');
mode = input(' (type in "randomized" or "ordered") ','s');
disp(' ');

if strcmp(mode, 'randomized')
    randomArray = randomNote(nArray);
end

while (k < 42)
    if strcmp(mode, 'randomized')
        n = randomArray(1,k);
    elseif strcmp(mode, 'ordered')
        n = nArray(1,k);
    end
    
    S = NoteCreator(n);
    k = k + 1;
    
%% Play Note and Record the Audio Signal

    replay = 'yes';
    while strcmp(replay, 'yes')
        pause(2);
        disp('Here is your note:');
        sound(S, Fs);                                                   %Plays note
        disp(['     Note Played: ', note(n).name]) 
        disp(['     Frequency of note: ', num2str(note(n).frequency)]);
        disp(' ');
        pause(1);
        disp('Ready to sing your note?');
        disp(' ');
        pause(1);
        disp('Sing and hold out your note now.');
        pause(1.5);
        disp('Start of Recording');
        recObj = audiorecorder(Fs, bits, 1, -1);             
        recordblocking(recObj, T);       % T stands for seconds
        disp(' ');
        disp('End of Recording');
        makeplot = false;   % Displays or not the fft graph of recorded sound
        sungFrequency = analyzer(recObj,makeplot);
        [frequencyError] = pitchError(sungFrequency, n);
        disp(['You sang at a ',num2str(sungFrequency),' frequency']);
        pause(2);
        disp(' ');
        disp('Do you want to sing this note again?');
        replay = input('(type in "yes" or "no") ','s');
        disp(' ');
    end
 
%% Analyze Sound and Display Frequency to User / Analyze Voice Type

    if abs(frequencyError) < 5 %hz, then the counter will go to a specific voice type
        if note(n).frequency >= 87.31 && note(n).frequency <= 261.63
            basscounter = basscounter + 1;
        end
        if note(n).frequency >= 130.81 && note(n).frequency <= 392
            tenorcounter = tenorcounter + 1;
        end
        if note(n).frequency >= 174.61 && note(n).frequency <= 523.25
            altocounter = altocounter + 1;
        end
        if note(n).frequency >= 261.63 && note(n).frequency <= 880
            sopranocounter = sopranocounter + 1;
        end
    end
end

%% Display the Vocal Types That the User Best Fits

vocaltype(1).name = 'Bass';
vocaltype(1).counter = basscounter;

vocaltype(2).name = 'Tenor';
vocaltype(2).counter = tenorcounter;

vocaltype(3).name = 'Alto';
vocaltype(3).counter = altocounter;

vocaltype(4).name = 'Soprano';
vocaltype(4).counter = sopranocounter;

array = [basscounter tenorcounter altocounter sopranocounter];
arrayMax = max(array);

if arrayMax == 0
    disp('You do not fit any vocal ranges!');
else
    disp('You best fit the following vocal type(s): ');
    
    for i = 1:4
        if (vocaltype(i).counter == arrayMax)
            disp(vocaltype(i).name);
        end
    end
end


