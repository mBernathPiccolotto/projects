function [randomArray] = randomNote(nArray)
% Author: Lauren Rymsza
% Date: April 18th, 2019
% This function creates a randomized array from numbers 1 to 41 in order to
% have no repeating notes for the user to sing

len = length(nArray);
for i = 1:len
    n = randi(len);
    while (nArray(1, n) == 0)
        n = randi(len);
    end
    randomArray(1, i) = n;
    nArray(1, n) = 0;
end
end

%create a new array with randomized numbers from 1 to 41