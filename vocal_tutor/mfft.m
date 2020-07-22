%% About this function

% mfft

% Makes a fast fourier transform

% By Marcelo Bernath Piccolotto

%% Input

function F = mfft(x)

%% Measures size of vector, if size is 1, returns vector

n = length(x);

if n == 1
    F=x;
    return
end

%% Separates vector X between odd and even positions

xEven = zeros(1,n/2);
xOdd = zeros(1,n/2);

for m = 0:n/2-1
    xEven(m+1) = x(2*m+1);
    xOdd(m+1) = x(2*m + 2);
end

%% Does the fourier tranform by dividing the sum

E = mfft(xEven);
O = mfft(xOdd);

F = zeros(0,n);

for k = 0:n/2-1
    F(k+1) = E(k+1) + exp(-2*pi*j*k/n)*O(k+1);
    F(k+n/2+1) = E(k+1) - exp(-2*pi*j*k/n)*O(k+1);
end