% signal map
close all;
p=1;

data_source = actrl_v6_006;

time = data_source.X(1,1).Data;
AvgCurrentCommand = data_source.Y(1,1).Data;
AvgCurrentMeasurement = data_source.Y(1,2).Data;

figure(p); p=p+1; legend_text = {};
hold on; grid on; grid minor;
stairs(time, AvgCurrentMeasurement, 'k');
stairs(time, AvgCurrentCommand, 'g');
legend_text = [ legend_text {'AvgCurrentMeasurement', 'AvgCurrentCommand'} ];
legend(legend_text);