% signal map
close all;
p=1;

data_source = actrl_v10_001;

time = data_source.X(1,1).Data;

DutyCycleCommandTop = data_source.Y(1,1).Data;


AvgCurrentCommand = data_source.Y(1,2).Data;
AvgCurrentMeasurement = data_source.Y(1,3).Data;

BatteryVoltage = data_source.Y(1,4).Data;
UCVoltageMeasurement = data_source.Y(1,5).Data;

% DutyCycleCommandBot = (AvgCurrentCommand<0) .* (1-DutyCycleCommandTop);


% figure(p); p=p+1; legend_text = {};
% hold on; grid on; grid minor;
% stairs(time, AvgCurrentMeasurement, 'k');
% stairs(time, AvgCurrentCommand, 'g');
% legend_text = [ legend_text {'AvgCurrentMeasurement', 'AvgCurrentCommand'} ];
% legend(legend_text);
% xlim([0 0.05]);

% figure(p); p=p+1; legend_text = {};
% hold on; grid on; grid minor;
% stairs(time, DutyCycleCommandTop, 'g', 'LineWidth', 2);
% legend_text = [ legend_text {'DutyCycleCommandTop'} ];
% legend(legend_text);
% 
% figure(p); p=p+1; legend_text = {};
% hold on; grid on; grid minor;
% stairs(time, BatteryVoltage, 'r');
% stairs(time, UCVoltageMeasurement, 'g');
% legend_text = [ legend_text {'UCVoltageCommand', 'UCVoltageMeasurement'} ];
% legend(legend_text);

get_frf(AvgCurrentMeasurement, AvgCurrentCommand, time, 0);