function [F_OUT,Y_MAG,Y_PHASE] = fft2(Fs, data)

%input: 
% Fs?sampling frequency
% data: time domain data

%================== FFT ==============================
T = 1/Fs;                      		% Sample time
L = length(data);                     % Length of signal
% t_fft = (0:L-1)*T;                 % Time vector

%NFFT = 2^nextpow2(L); % Next power of 2 from length of y
NFFT=L;
Y = fft(data,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

Y_OUT=2*Y(2:(NFFT/2+1));
F_OUT=f(2:(NFFT/2+1));
%==========================

%output is in complex value. use abs() and phase() to get MAGNITUDE AND PHASE info.

Y_MAG = abs(Y_OUT);
Y_PHASE = rad2deg( wrapToPi( phase(Y_OUT) ) );

end

