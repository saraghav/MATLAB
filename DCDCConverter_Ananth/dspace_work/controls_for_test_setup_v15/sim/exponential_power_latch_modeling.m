% exponential power latch modeling

% tf_to_use = tf_IL_ILcommand_Ponly_z;
tf_to_use = tf_IL_ILcommand_z;

[ct_mag, ct_phase, ct_freq] = bode(tf_to_use);

% the returned values have redundant dimensions
% following code eliminates redundant dimensions, making it possible to
% plot directly
ct_mag = squeeze(ct_mag);
ct_phase = squeeze(ct_phase);
ct_freq = squeeze(ct_freq);
ct_frf_complex = ct_mag .* ( cosd(ct_phase) + 1i *sind(ct_phase) );

% input: ones(length(ct_freq), 1)
% output: ct_frf_complex
% frequency: ct_freq*2*pi
% frequency unit: rad/s
% sampling interval: Ts