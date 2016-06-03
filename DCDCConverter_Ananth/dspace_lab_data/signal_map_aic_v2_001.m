% signal map
close all;
p=1;

time = aic_v2_001.X(1,1).Data;
time2 = aic_v2_001.X(1,2).Data;

BatteryPower = aic_v2_001.Y(1,1).Data;
Efficiency = aic_v2_001.Y(1,2).Data;
UltracapacitorPower = aic_v2_001.Y(1,3).Data;

BatteryVoltage = aic_v2_001.Y(1,5).Data;
BatteryCurrent = aic_v2_001.Y(1,4).Data;
VUC = aic_v2_001.Y(1,7).Data;
IUC = aic_v2_001.Y(1,6).Data;

Clock = aic_v2_001.Y(1,8).Data;

DutyCycleBot = aic_v2_001.Y(1,9).Data;
DutyCycleTop = aic_v2_001.Y(1,10).Data;

figure(p); p=p+1;
hold on; grid on; grid minor;
stairs(time, BatteryVoltage);
stairs(time, VUC, 'r');
legend('BatteryVoltage','VUC');

figure(p); p=p+1;
hold on; grid on; grid minor;
stairs(time, BatteryCurrent);
stairs(time, IUC, 'r');
legend('BatteryCurrent','IUC');

figure(p); p=p+1;
hold on; grid on; grid minor;
stairs(time2, DutyCycleBot, 'LineWidth', 3);
stairs(time2, DutyCycleTop, 'r', 'LineWidth', 3);
legend('DutyCycleBot','DutyCycleTop');