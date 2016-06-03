% system parameters

% defines these variables: Vbat, L, C, R, fs, Ts, del, w_r

% Required to be global because other scripts (like z_pow.m for example)
% use this information (from global variables)
global Ts; % current loop
global Ts2; % voltage loop

% Circuit Parameters
Vbat = 12.1;
L = 137e-6; % 3 Inductances in Series
C = 165; % Ultracap capacitance
R_C = 5.5e-3; % Ultracap resistance
R_L = 1.608e-3; % Inductor resistance
R = R_C + R_L; % Ultracap resistance + Inductor Resistance
Rbat = 4*1.8e-3; % 4 batteries in series

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

% Sampling time for implementation and simulink simulation solver period
Tsample_simulink = Ts/10;

% For dSPACE Implementation
Ireg_Integ_Limit = Vbat-1;
Icommand_Limit = 200; % Limit current command to 200A for the test setup
Vreg_Integ_Limit = Icommand_Limit - 1;

% For State Machine
Vrail_rated = Vbat;
BatVoltageLowerThresh = Vbat - Rbat*Icommand_Limit;
BatVoltageUpperThresh = Vbat + Rbat*Icommand_Limit;
UCVoltageLowerThresh = 0;
UCVoltageUpperThresh = Vbat-1;

% For Trip Settings
MaxBatCurrent = 0.7 * Icommand_Limit;
MaxUCCurrent = 250;
MaxBatVoltage = 1.2 * BatVoltageUpperThresh;
MaxUCVoltage = 1.2 * UCVoltageUpperThresh;
MaxTemperature = 70;

% To avoid current arcs in the relays when the system trips
TDelay_UltracapacitorRelay = 0.5;