% system parameters

% defines these variables: Vbat, L, C, R, fs, Ts, del, w_r

% Required to be global because other scripts (like z_pow.m for example)
% use this information (from global variables)
global Ts; % current loop
global Ts2; % voltage loop

% Circuit Parameters
Vbat = 12.5;
L = 3 * 65e-6; % 3 Inductances in Series
C = 188; % Ultracap capacitance
R = 5.5e-3 + 3 * 1.2e-3; % Ultracap resistance + 3 x Inductor Resistance

del = R/2*sqrt(C/L); % calculated damping ration
w_r = 1/sqrt(L*C); % calculated resonant frequency

% Current Loop
fs = 5e3;
Ts = 1/fs;

% Voltage Loop
% max iavg permitted is 200A
% controller designed to recognize a 0.05V change in measurement
% when peak current is commanded
fs2 = 20;
Ts2 = 1/fs2;

% Sample rate and simulation period
Tsample_simulink = Ts/10;

% For dSPACE Implementation
Ireg_Integ_Limit = Vbat - 0.5;
Icommand_Limit = 200; % Limit current command to 10A for the test setup
Vreg_Integ_Limit = Icommand_Limit - 1;