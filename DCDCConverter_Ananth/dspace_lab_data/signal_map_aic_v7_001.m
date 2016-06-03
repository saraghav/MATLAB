% signal map
close all;
p=1;

time = aic_v7_001.X(1,1).Data;
% time2 = aic_v7_001.X(1,2).Data;

IUC_uf = aic_v7_001.Y(1,1).Data;
IUC_ss = aic_v7_001.Y(1,2).Data;

figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, IUC_uf, 'k');
stairs(time, IUC_ss, 'b', 'LineWidth', 2);
legend_text = [ legend_text {'IUC\_uf', 'IUC\_ss'} ];

% stairs(time2, DutyCycleTop, 'r', 'LineWidth', 3);
% legend_text = [ legend_text {'DutyCycleTop'} ];
legend(legend_text);


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