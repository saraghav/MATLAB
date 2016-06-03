% signal map
close all;
p=1;

time = aic_v5_001.X(1,1).Data;
time2 = aic_v5_001.X(1,2).Data;

BatteryPower = aic_v5_001.Y(1,3).Data;
Efficiency = aic_v5_001.Y(1,6).Data;
UltracapacitorPower = aic_v5_001.Y(1,9).Data;

BatteryVoltage = aic_v5_001.Y(1,4).Data;
BatteryCurrent = aic_v5_001.Y(1,1).Data;
VUC = aic_v5_001.Y(1,10).Data;
IUC = aic_v5_001.Y(1,7).Data;

% uf = unfiltered
BatteryVoltage_uf = aic_v5_001.Y(1,5).Data;
BatteryCurrent_uf = aic_v5_001.Y(1,2).Data;
VUC_uf = aic_v5_001.Y(1,11).Data;
IUC_uf = aic_v5_001.Y(1,8).Data;

Clock = aic_v5_001.Y(1,12).Data;

DutyCycleBot = aic_v5_001.Y(1,13).Data;
DutyCycleTop = aic_v5_001.Y(1,14).Data;


figure(p); p=p+1;
hold on; grid on; grid minor;
stairs(time, BatteryVoltage_uf, 'g');
stairs(time, VUC_uf, 'k');
legend('BatteryVoltage\_uf','VUC\_uf');

% figure(p); p=p+1;
hold on; grid on; grid minor;
stairs(time, BatteryVoltage);
stairs(time, VUC, 'r');
legend('BatteryVoltage','VUC');


figure(p); p=p+1;
hold on; grid on; grid minor;
stairs(time, BatteryCurrent_uf, 'g');
stairs(time, IUC_uf, 'k');
legend('BatteryCurrent\_uf','IUC\_uf');

% figure(p); p=p+1;
hold on; grid on; grid minor;
stairs(time, BatteryCurrent);
stairs(time, IUC, 'r');
legend('BatteryCurrent','IUC');


figure(p); p=p+1;
hold on; grid on; grid minor;
stairs(time2, DutyCycleBot, 'LineWidth', 3);
stairs(time2, DutyCycleTop, 'r', 'LineWidth', 3);
legend('DutyCycleBot','DutyCycleTop');


%% viewing downsampled current
 
% temp1 = time(70050:70120);
% temp2 = IUC_uf(70050:70120);
% stairs(temp1, temp2);
% 
% % every 4 samples because sampling freq = 4*pwm freq
% temp3 = temp1(4:4:end);
% temp4 = temp2(4:4:end);
% 
% figure(1);
% stairs(temp1, temp2);
% hold on; grid on;
% stairs(temp3, temp4, 'r');