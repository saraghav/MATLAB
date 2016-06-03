% signal map
close all;
p=1;

data_source = Lead_Acid_0C_002;

time = data_source.X(1,1).Data;

% BatteryCurrent = data_source.Y(1,1).Data;
% AvgCurrentCommand = data_source.Y(1,2).Data;
% AvgCurrentMeasurement = data_source.Y(1,3).Data;
% BatteryVoltage = data_source.Y(1,4).Data;
% 
% BatteryVoltageDisturbance = data_source.Y(1,5).Data;
% UCCurrentDisturbance = data_source.Y(1,6).Data;
% UCVoltageCommand = data_source.Y(1,7).Data;
% UCVoltageMeasurement = data_source.Y(1,8).Data;
% 
% DutyCycleCommandBot = data_source.Y(1,9).Data;
% DutyCycleCommandTop = data_source.Y(1,10).Data;

% AvgCurrentMeasurement = data_source.Y(1,1).Data;
% EnableAutomaticControl = data_source.Y(1,2).Data;
% CurrentControlMode = data_source.Y(1,3).Data;
% DutyCycleCommandBot = data_source.Y(1,4).Data;
% DutyCycleCommandTop = data_source.Y(1,5).Data;
% AvgCurrentCommand = data_source.Y(1,6).Data;
% UCVoltageCommand = data_source.Y(1,7).Data;
% BatteryVoltage = data_source.Y(1,8).Data;
% BatteryVoltageDerivative = data_source.Y(1,9).Data;


BatteryCurrent = data_source.Y(1,1).Data;
BatteryVoltage = data_source.Y(1,2).Data;
UCCurrent = data_source.Y(1,3).Data;
UCVoltage = data_source.Y(1,4).Data;
CurrentControlMode = data_source.Y(1,5).Data;
DutyCycleCommandBot = data_source.Y(1,6).Data;
DutyCycleCommandTop = data_source.Y(1,7).Data;
UCCurrentCommand = data_source.Y(1,8).Data;
UCVoltageCommand = data_source.Y(1,9).Data;


% plots

figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, UCCurrent, 'k'); legend_text = [ legend_text {'UCCurrent'} ];
stairs(time, UCCurrentCommand, 'm'); legend_text = [ legend_text {'UCCurrentCommand'} ];
legend(legend_text{:});

figure(p); p=p+1; legend_text = {};
stairs(time, UCVoltage, 'b'); legend_text = [ legend_text {'UCVoltage'} ];
stairs(time, BatteryVoltage, 'g'); legend_text = [ legend_text {'BatteryVoltage'} ];
legend(legend_text{:});

% stairs(time, BatteryCurrent, 'r'); legend_text = [ legend_text {'BatteryCurrent'} ];
% stairs(time, CurrentControlMode*80, 'c'); legend_text = [ legend_text {'CurrentControlMode'} ];
% stairs(time, DutyCycleCommandBot*100, 'm'); legend_text = [ legend_text {'DutyCycleCommandBot'} ];
% stairs(time, DutyCycleCommandTop*100, 'y'); legend_text = [ legend_text {'DutyCycleCommandTop'} ];
% stairs(time, UCVoltageCommand, 'y'); legend_text = [ legend_text {'UCVoltageCommand'} ];
% legend(legend_text);

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
