% signal map
close all;
p=1;

time = exp3_001.X(1,1).Data;
time2 = exp3_001.X(1,2).Data;

BatteryPower = exp3_001.Y(1,1).Data;
Efficiency = exp3_001.Y(1,2).Data;
UltracapacitorPower = exp3_001.Y(1,3).Data;

BatteryVoltage = exp3_001.Y(1,5).Data;
BatteryCurrent = exp3_001.Y(1,4).Data;
VUC = exp3_001.Y(1,7).Data;
IUC = exp3_001.Y(1,6).Data;

Clock = exp3_001.Y(1,8).Data;

DutyCycleBot = exp3_001.Y(1,9).Data;
DutyCycleTop = exp3_001.Y(1,10).Data;

figure(p); p=p+1;
hold on; grid on; grid minor;
plot(time, BatteryVoltage);
plot(time, VUC, 'r');
legend('BatteryVoltage','VUC');

figure(p); p=p+1;
hold on; grid on; grid minor;
plot(time, BatteryCurrent);
plot(time, IUC, 'r');
legend('BatteryCurrent','IUC');

figure(p); p=p+1;
hold on; grid on; grid minor;
plot(time2, DutyCycleBot, 'LineWidth', 3);
plot(time2, DutyCycleTop, 'r', 'LineWidth', 3);
legend('DutyCycleBot','DutyCycleTop');