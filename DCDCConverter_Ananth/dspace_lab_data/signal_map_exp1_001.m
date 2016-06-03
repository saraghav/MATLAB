% signal map
time = exp1_001.X(1,1).Data;
BatteryVoltage = exp1_001.Y(1,5).Data;
BatteryCurrent = exp1_001.Y(1,4).Data;
VUC = exp1_001.Y(1,7).Data;
IUC = exp1_001.Y(1,6).Data;

figure(1);
hold on; grid on; grid minor;
plot(time, BatteryVoltage);
plot(time, VUC, 'r');

figure(3);
hold on; grid on; grid minor;
plot(time, BatteryCurrent);
plot(time, IUC, 'r');