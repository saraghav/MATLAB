% signal map
close all;
p=1;

data_source = actrl_v12_004;

time = data_source.X(1,1).Data;

BatteryCurrent = data_source.Y(1,1).Data;
AvgCurrentCommand = data_source.Y(1,2).Data;
AvgCurrentMeasurement = data_source.Y(1,3).Data;
BatteryVoltage = data_source.Y(1,4).Data;

BatteryVoltageDisturbance = data_source.Y(1,5).Data;
UCCurrentDisturbance = data_source.Y(1,6).Data;
UCVoltageCommand = data_source.Y(1,7).Data;
UCVoltageMeasurement = data_source.Y(1,8).Data;

DutyCycleCommandBot = data_source.Y(1,9).Data;
DutyCycleCommandTop = data_source.Y(1,10).Data;


% plots

figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, AvgCurrentMeasurement, 'k');
stairs(time, AvgCurrentCommand, 'g');
legend_text = [ legend_text {'AvgCurrentMeasurement', 'AvgCurrentCommand'} ];
legend(legend_text);

figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, DutyCycleCommandTop, 'r', 'LineWidth', 2);
stairs(time, DutyCycleCommandBot, 'b', 'LineWidth', 2);
legend_text = [ legend_text {'DutyCycleCommandTop', 'DutyCycleCommandBot'} ];
legend(legend_text);

figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, BatteryVoltage, 'r');
stairs(time, UCVoltageCommand, 'b', 'LineWidth', 3);
stairs(time, UCVoltageMeasurement, 'g', 'LineWidth', 3);
legend_text = [ legend_text {'BatteryVoltage', 'UCVoltageCommand', 'UCVoltageMeasurement'} ];
legend(legend_text);

% Current Command Tracking
% get_frf(AvgCurrentMeasurement, AvgCurrentCommand, time, 0);

% Current Dynamic Stiffness
% get_frf(BatteryVoltageDisturbance, AvgCurrentMeasurement, time, 1);


% Ts = 2e-4; Ts2 = 1; downsampling = Ts2/Ts;
% time2 = time(1:downsampling:end);
% UCVoltageMeasurement2 = UCVoltageMeasurement(1:downsampling:end);
% UCVoltageCommand2 = UCVoltageCommand(1:downsampling:end);
% UCCurrentDisturbance2 = UCCurrentDisturbance(1:downsampling:end);


% Voltage Command Tracking
% get_frf2(UCVoltageMeasurement2, UCVoltageCommand2, time2, 0);

% Voltage Dynamic Stiffness
% get_frf2(UCCurrentDisturbance2, UCVoltageMeasurement2, time2, 1);
