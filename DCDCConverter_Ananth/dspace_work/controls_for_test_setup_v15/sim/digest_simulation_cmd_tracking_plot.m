% simulation command tracking

% smooth buck-boost control plots
if ~exist('p', 'var')
    p = 1;
end
clear start_time end_time;

time = command_tracking.time;
Iavg_cmd = command_tracking.signals.values(:,1);
Iavg = command_tracking.signals.values(:,2);

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
Iavg = Iavg(subset);

[mag, phase, freq] = get_frf(Iavg, Iavg_cmd, time, 0);
