% simulink simulation settings

% timeseries command
wcmd_timeseries = timeseries;
wcmd_timeseries.Time = 0;
wcmd_timeseries.Data = 0;

% transfer function command
ILcommand_z = tf(0);

% initial ultracapacitor voltage
Vinit = 7;