function [] = Vocal_type_practice()

%% Feature 2: Practicing Voice Type
 % Lauren Rymsza 
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
 
voicePractice = ' ';
disp('What vocal range do you want to practice?');
voicePractice = input(' (type "soprano", "alto", "tenor", or "bass") ','s');
 
if strcmp(voicePractice, 'soprano')
    for k = 20:41
        n = nArray(1,k);
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
            [frequencyError, centsError] = pitchError(sungFrequency, n);
            disp(['You sang at a ',num2str(sungFrequency),' frequency']);
            disp(['Your frequency error: ', num2str(frequencyError), ' Hz']);
            disp(['Your cent error: ', num2str(centsError), ' cents']);
            if frequencyError < 0
                disp('You are flat');
            else
                disp('You are sharp');
            end
            pause(2);
            disp(' ');
            disp('Do you want to sing this note again?');
            replay = input('(type in "yes" or "no") ','s');
            disp(' ');
        end
        
        %% Analyze Sound and Display Frequency to User / Analyze Voice Type
        
        if abs(frequencyError) < 5 %hz, then the counter will go to a specific voice type
            sopranocounter = sopranocounter + 1;
        end
    end
    
    %% Display the Vocal Type Results    
    if sopranocounter == 0
        disp('You did not do that well!');
    else
        disp(['You hit these many notes with minimal error: ', num2str(sopranocounter)]);
    end
elseif strcmp(voicePractice, 'alto')
    for k = 13:32
        n = nArray(1,k);
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
            [frequencyError, centsError] = pitchError(sungFrequency, n);
            disp(['You sang at a ',num2str(sungFrequency),' frequency']);
            disp(['Your frequency error: ', num2str(frequencyError), ' Hz']);
            disp(['Your cent error: ', num2str(centsError), ' cents']);
            if frequencyError < 0
                disp('You are flat');
            else
                disp('You are sharp');
            end
            pause(2);
            disp(' ');
            disp('Do you want to sing this note again?');
            replay = input('(type in "yes" or "no") ','s');
            disp(' ');
        end
        
        %% Analyze Sound and Display Frequency to User / Analyze Voice Type
        
        if abs(frequencyError) < 5 %hz, then the counter will go to a specific voice type
            altocounter = altocounter + 1;
        end
    end
    
    %% Display the Vocal Type Results    
    if altocounter == 0
        disp('You did not do that well!');
    else
        disp(['You hit these many notes with minimal error: ', num2str(altocounter)]);
    end
elseif strcmp(voicePractice, 'tenor')
    for k = 8:27
        n = nArray(1,k);
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
            [frequencyError, centsError] = pitchError(sungFrequency, n);
            disp(['You sang at a ',num2str(sungFrequency),' frequency']);
            disp(['Your frequency error: ', num2str(frequencyError), ' Hz']);
            disp(['Your cent error: ', num2str(centsError), ' cents']);
            if frequencyError < 0
                disp('You are flat');
            else
                disp('You are sharp');
            end
            pause(2);
            disp(' ');
            disp('Do you want to sing this note again?');
            replay = input('(type in "yes" or "no") ','s');
            disp(' ');
        end
        
        %% Analyze Sound and Display Frequency to User / Analyze Voice Type
        
        if abs(frequencyError) < 5 %hz, then the counter will go to a specific voice type
            tenorcounter = tenorcounter + 1;
        end
    end
    
    %% Display the Vocal Type Results    
    if tenorcounter == 0
        disp('You did not do that well!');
    else
        disp(['You hit these many notes with minimal error: ', num2str(tenorcounter)]);
    end
else
    for k = 1:20
        n = nArray(1,k);
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
            [frequencyError, centsError] = pitchError(sungFrequency, n);
            disp(['You sang at a ',num2str(sungFrequency),' frequency']);
            disp(['Your frequency error: ', num2str(frequencyError), ' Hz']);
            disp(['Your cent error: ', num2str(centsError), ' cents']);
            if frequencyError < 0
                disp('You are flat');
            else
                disp('You are sharp');
            end
            pause(2);
            disp(' ');
            disp('Do you want to sing this note again?');
            replay = input('(type in "yes" or "no") ','s');
            disp(' ');
        end
        
        %% Analyze Sound and Display Frequency to User / Analyze Voice Type
        
        if abs(frequencyError) < 5 %hz, then the counter will go to a specific voice type
            basscounter = basscounter + 1;
        end
    end
    
    %% Display the Vocal Type Results    
    if basscounter == 0
        disp('You did not do that well!');
    else
        disp(['You hit these many notes with minimal error: ', num2str(basscounter)]);
    end
end


