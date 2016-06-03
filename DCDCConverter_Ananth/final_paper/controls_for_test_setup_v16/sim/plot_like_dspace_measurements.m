% signal map
% close all;
p=1;

data_source = plecs_measurements;

time = data_source.time;

UCVoltageMeasurement = data_source.signals.values(:,1);
BatteryVoltage = data_source.signals.values(:,2);
AvgCurrentCommand = data_source.signals.values(:,3);
AvgCurrentMeasurement = data_source.signals.values(:,4);
DutyCycleCommand = data_source.signals.values(:,5);

% plots

%% current command tracking - time domain
figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, AvgCurrentCommand); legend_text = [ legend_text 'Avg Current Command' ];
stairs(time, AvgCurrentMeasurement); legend_text = [ legend_text 'Avg Current Measurement' ];
stairs(time, BatteryVoltage); legend_text = [ legend_text 'Battery Voltage' ];
stairs(time, UCVoltageMeasurement); legend_text = [ legend_text 'UC Voltage' ];
legend(legend_text);

%% Current Command Tracking - FRF
% get_frf(AvgCurrentMeasurement, AvgCurrentCommand, time, 0);

%% Current Dynamic Stiffness - FRF
% get_frf(BatteryVoltageDisturbance, AvgCurrentMeasurement, time, 1);