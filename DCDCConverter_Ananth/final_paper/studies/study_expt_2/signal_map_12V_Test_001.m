% signal map
% close all;
p=1;

data_source = data_source2;

time = data_source.X(1,1).Data;
time = time - time(1); % remove time offset

BatteryVoltage = data_source.Y(1,1).Data;
LoadCurrent = data_source.Y(1,2).Data;
CurrentControlMode = data_source.Y(1,3).Data;
DutyCycleCommandBot = data_source.Y(1,4).Data;
DutyCycleCommandTop = data_source.Y(1,5).Data;
AvgCurrentCommand = data_source.Y(1,6).Data;
AvgCurrentMeasurement = data_source.Y(1,7).Data;
UCVoltageCommand = data_source.Y(1,8).Data;
UCVoltageMeasurement = data_source.Y(1,9).Data;

% change sampling rate for voltage signals
Ts = 2e-4; Ts2 = 1; downsampling = Ts2/Ts;  
time2 = time(1:downsampling:end);
UCVoltageMeasurement2 = UCVoltageMeasurement(1:downsampling:end);
UCVoltageCommand2 = UCVoltageCommand(1:downsampling:end);
% UCCurrentDisturbance2 = UCCurrentDisturbance(1:downsampling:end);

% plots

%% current command tracking - time domain
figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
% stairs(time, AvgCurrentCommand); legend_text = [ legend_text 'Avg Current Command' ];
% stairs(time, AvgCurrentMeasurement); legend_text = [ legend_text 'Avg Current Measurement' ];
stairs(time, BatteryVoltage); legend_text = [ legend_text 'Battery Voltage' ];
stairs(time, UCVoltageMeasurement); legend_text = [ legend_text 'UC Voltage' ];
legend(legend_text);

%% Current Command Tracking - FRF
% get_frf(AvgCurrentMeasurement, AvgCurrentCommand, time, 0);

%% Current Dynamic Stiffness - FRF
% get_frf(BatteryVoltageDisturbance, AvgCurrentMeasurement, time, 1);

%% Voltage Command Tracking
% get_frf2(UCVoltageMeasurement2, UCVoltageCommand2, time2, 0);

%% Voltage Dynamic Stiffness
% get_frf2(UCCurrentDisturbance2, UCVoltageMeasurement2, time2, 1);
