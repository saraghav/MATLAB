% signal map
close all;
p=1;

data_source = actrl_v3_001;

time = data_source.X(1,1).Data;
time2 = data_source.X(1,2).Data;

BatteryPower = data_source.Y(1,3).Data;
Efficiency = data_source.Y(1,6).Data;
UltracapacitorPower = data_source.Y(1,9).Data;

BatteryVoltage = data_source.Y(1,4).Data;
BatteryCurrent = data_source.Y(1,1).Data;
VUC = data_source.Y(1,10).Data;
IUC = data_source.Y(1,7).Data;

% uf = unfiltered`
BatteryVoltage_uf = data_source.Y(1,5).Data;
BatteryCurrent_uf = data_source.Y(1,2).Data;
VUC_uf = data_source.Y(1,11).Data;
IUC_uf = data_source.Y(1,8).Data;

Clock = data_source.Y(1,12).Data;

DutyCycleBot = data_source.Y(1,13).Data;
DutyCycleTop = data_source.Y(1,14).Data;

% controller signals
CurrentError = data_source.Y(1,15).Data;
DutyCycleCommand = data_source.Y(1,16).Data;
IntegralControlCommand = data_source.Y(1,17).Data;
ProportionalControlCommand = data_source.Y(1,18).Data;
AvgCurrentCommand = data_source.Y(1,19).Data;
AvgCurrentMeasurement = data_source.Y(1,20).Data;
DCBusVoltageMeasurement = data_source.Y(1,21).Data;


figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, BatteryVoltage_uf, 'g');
stairs(time, VUC_uf, 'k');
legend_text = [ legend_text {'BatteryVoltage\_uf','VUC\_uf'} ];
legend(legend_text);

% figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, BatteryVoltage);
stairs(time, VUC, 'r');
legend_text = [ legend_text {'BatteryVoltage','VUC'} ];
legend(legend_text);


figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, BatteryCurrent_uf, 'g');
stairs(time, IUC_uf, 'k');
legend_text = [ legend_text {'BatteryCurrent\_uf','IUC\_uf'} ];
legend(legend_text);

% figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, BatteryCurrent);
stairs(time, IUC, 'r');
legend_text = [ legend_text {'BatteryCurrent','IUC'} ];
legend(legend_text);


figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time2, DutyCycleBot, 'LineWidth', 3);
stairs(time2, DutyCycleTop, 'r', 'LineWidth', 3);
legend_text = [ legend_text {'DutyCycleBot','DutyCycleTop'} ];
legend(legend_text);


figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, AvgCurrentMeasurement, 'k');
stairs(time, AvgCurrentCommand, 'g');
stairs(time, (ProportionalControlCommand+IntegralControlCommand)/10, 'r', 'LineWidth', 3);
legend_text = [ legend_text {'AvgCurrentMeasurement', 'AvgCurrentCommand'} ];
legend(legend_text);

figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
% plotyy(time, CurrentError, time, DutyCycleCommand);
stairs(time, CurrentError);
stairs(time, DutyCycleCommand, 'g', 'LineWidth', 2);
legend_text = [ legend_text {'CurrentError', 'DutyCycleCommand'} ];
legend(legend_text);


figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, ProportionalControlCommand);
stairs(time, IntegralControlCommand, 'g', 'LineWidth', 2);
legend_text = [ legend_text {'ProportionalControlCommand', 'IntegralControlCommand'} ];
legend(legend_text);
