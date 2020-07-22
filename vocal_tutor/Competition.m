%% Singing Competition Game

% By Marcelo Bernath Piccolotto

%% Input

function [] = Competition()

clc
clear all

load('AudioParameters.mat');
load('Notes.mat');

disp('How many players?');
nplayers = input('');

disp('What is the Maximum frequency you want the game to use?');
maxfreq = input('');

disp('What is the Minimum frequency you want the game to use?');
minfreq = input('');

disp('How many rounds do you want to play?');
rounds = input('');
disp(' ')
disp(' ')

for i = 1:nplayers
    disp(['Enter player ', num2str(i), ' name.'])
    players{1, i} = input('', 's');
end % Enter player names

clc

%% Compute

usr = 1;

for i = 1:rounds
 
    disp(['Time for round ', num2str(i)])
    pause(2);
    n = randi(41);
    while note(n).frequency < minfreq || note(n).frequency > maxfreq
        n = randi(41);
    end
    S = NoteCreator(n);
    disp(['The sound will be ', num2str(note(n).frequency), ' Hz'])
    pause(1);
    sound(S, Fs);
    pause(2);
    for y = 1:nplayers
        ready = false;
        while ready == false
            disp([players{1, y}, ', enter Go when you are ready']);
            go = input('', 's');
            if strcmpi(go, 'Go')
                ready = true;
            end
        end
        disp('Listen to the note again and sing')
        sound(S, Fs);
        pause(1);
        disp('Sing and hold out your note now:');
        pause(1)
        disp('Start of Recording.');
        recObj = audiorecorder(Fs, bits, 1, - 1);
        recordblocking(recObj, T);
        disp('End of Recording');
        pause(1)
        makeplot = false;
        sungFrequency = analyzer(recObj, makeplot);
        diference = abs(note(n).frequency - sungFrequency);
        disp(['You sang at a ', num2str(sungFrequency), '. Your diference is ', ...
          num2str(diference)]);
        players{i + 1, y} = diference;
        pause(5)
        clc
    end
end % Runs the game

for i = 1:nplayers % Sums each players frequency diference over the rounds
    players{rounds + 2, i} = 0;
    for y = 1:rounds
        players{rounds + 2, i} = players{y + 1, i} + players{rounds + 2, i};
    end
end

disp('Game over!')
disp(' ')
pause(2)
disp('Here are the results')
disp(' ')
disp(' ')
pause(1)

min = 100000000000;

for i = 1:nplayers % Calculates player Positions and displays
    min = 100000000000;
    for y = 1:nplayers
        if players{rounds + 2, y} < min
            winner = y;
        end
    end
    pause(1)
    if i == 1
        disp([num2str(i), 'st place is ', players{1, i}])
    elseif i == 2
        disp([num2str(i), 'nd place is ', players{1, i}])
    elseif i == 3
        disp([num2str(i), 'rd place is ', players{1, i}])
    else
        disp([num2str(i), 'th place is ', players{1, i}])
    end
    players{rounds + 2, i} = 1000000;
end