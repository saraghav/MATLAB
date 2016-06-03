% smooth buck-boost control plots
if ~exist('p', 'var')
    p = 1;
end
clear start_time end_time;

% load digest_plot_data_output_2;
% load digest_plot_data_output_1;

time = step_transient.time;
Iavg_cmd = step_transient.signals.values(:,1);
Iact = step_transient.signals.values(:,2);
Iavg = step_transient.signals.values(:,3);
Vuc = step_transient.signals.values(:,4);

start_time = 1.5;
% end_time = 0.5;

if ~exist('start_time', 'var')
    start_time = time(1);
end
if ~exist('end_time', 'var')
    end_time = time(end);
end

subset = (time >= start_time) & (time <= end_time);
time = time(subset);
Iavg_cmd = Iavg_cmd(subset);
Iact = Iact(subset);
Iavg = Iavg(subset);
Vuc = Vuc(subset);

R = 5.5e-3 + 1.608e-3;
Vucmeas = Vuc + Iavg*R;

time = time - start_time;

% figure(p); hold on; grid on; grid minor; p=p+1;
% stairs(time, Iact);
% stairs(time, Iavg_cmd, 'LineWidth', 2);
% stairs(time, Iavg, 'LineWidth', 2);
% ylim([-7 15]);
