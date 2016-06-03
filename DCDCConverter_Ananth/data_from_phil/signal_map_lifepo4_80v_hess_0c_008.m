% signal map
close all;
p=1;

data_source = LiFePO4_80V_HESS_0C_002;
% data_source = V_HESS_014; % 80V_HESS_018

time = data_source.X(1,1).Data;

BatteryVoltage = data_source.Y(1,1).Data;
LoadCurrent = data_source.Y(1,2).Data;
BatteryCurrent = data_source.Y(1,3).Data;
CurrentControlMode = data_source.Y(1,4).Data;
DutyCycleCommandBottom = data_source.Y(1,5).Data;
DutyCycleCommandTop = data_source.Y(1,6).Data;
AvgCurrentCommand = data_source.Y(1,7).Data;
AvgCurrentMeasurement = data_source.Y(1,8).Data;
UCVoltageCommand = data_source.Y(1,9).Data;
UCVoltageMeasurement = data_source.Y(1,10).Data;

% command saturation
cmd_gt = AvgCurrentCommand >= 200;
cmd_lt = AvgCurrentCommand <= -200;
AvgCurrentCommand(cmd_gt) = 200;
AvgCurrentCommand(cmd_lt) = -200;

plot_start_time = 17791.373056;
plot_end_time = 17805.458947;
plot_duration = plot_end_time - plot_start_time;
time = time - plot_start_time;

figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, AvgCurrentMeasurement, 'k', 'LineWidth', 2);
stairs(time, AvgCurrentCommand, 'g', 'LineWidth', 2);
legend_text = [ legend_text {'AvgCurrentMeasurement', 'AvgCurrentCommand'} ];
% legend(legend_text);
xlim([0 plot_duration]);
ylim([-250 250]);

% figure(p); p=p+1; legend_text = {};
% hold on; grid on; grid minor;
% stairs(time, DutyCycleCommandTop, 'g', 'LineWidth', 2);
% legend_text = [ legend_text {'DutyCycleCommandTop'} ];
% legend(legend_text);

figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, BatteryVoltage, 'r', 'LineWidth', 2); legend_text = [legend_text 'BatteryVoltage'];
stairs(time, UCVoltageMeasurement, 'g', 'LineWidth', 2); legend_text = [legend_text 'UCVoltageMeasurement'];
% legend(legend_text{:});
xlim([0 plot_duration]);
ylim([0 100]);

return;

% plot for paper
figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
offset = 17578.286591;
duration = 20;
x1 = [time', time'];
y1 = [AvgCurrentMeasurement', AvgCurrentCommand'];
legend_text = [legend_text {'AvgCurrentMeasurement', 'AvgCurrentCommand'}];
x2 = x1;
y2 = [BatteryVoltage', UCVoltageMeasurement'];
legend_text = [legend_text {'BatteryVoltage', 'UCVoltageMeasurement'}];
[hAx, HLine1, HLine2] = plotyy(x1, y1, x2, y2, @stairs, @stairs);
% legend(legend_text{:});
% xlim([0 duration]);
Hline1(:).LineWidth = 3;
ylim(hAx(1), [-250 250]);
ylim(hAx(2), [-100 100]);

% get_frf(AvgCurrentMeasurement, AvgCurrentCommand, time, 0);