% system model v5 - essentially v4 model, but with some additional states
clear;
close all;
clc;
% update: corrected value for resistance (includes ultracap resistance now)
% makes system overdamped unlke the previous case, where the system was
% underdamped

% load these variables: Vbat, L, C, R, fs, Ts, del, w_r
load_system_parameters;

z_m1 = z_pow(1,-1); % z^-1

%% get characteristic equation roots and calculate constants used in the Z-domain model

% eqn = s^2 + (R/L) * s + 1/(L*C), roots = -p1, -p2
char_eqn_coeffs_s = [ 1 R/L 1/(L*C) ];
char_eqn_roots_s = roots(char_eqn_coeffs_s);
if ( isreal(char_eqn_roots_s) == 0 )
    disp('Characteristic equation roots are not real => underdamped system');
    disp('Stopping simulation since design has been done for overdamped system');
    return;
end
% exactly two roots since it is a second order charateristic equation
p1 = max(-char_eqn_roots_s);
p2 = min(-char_eqn_roots_s);
if (p1 == p2)
    disp('Characteristic equation roots are equal => critically damped system');
    disp('Stopping simulation since design needs to be reviewed before deploying on critically damped system');
    return;
end

Ka = (p1-p2) + p2*exp(-p1*Ts) - p1*exp(-p2*Ts);
d_p1 = exp(-p1*Ts);
d_p2 = exp(-p2*Ts);
d_z = -1/Ka * ( (p1-p2)*exp(-(p1+p2)*Ts) + p2*exp(-p2*Ts) - p1*exp(-p1*Ts) );
d_z2 = (p1*d_p2-p2*d_p1) / (p1-p2);
Kb = Ka/( p1*p2*(p1-p2) );
Kd = (d_p2-d_p1)/(p1-p2);

%% define the known transfer functions

tf_dILdt_V_z = w_r^2*C * (1-d_z2*z_m1)*(1-z_m1) / ( (1-d_p1*z_m1) * (1-d_p2*z_m1) );
tf_delIL_V_z = Kd * w_r^2*C * z_m1*(1-z_m1)^2 / ( (1-d_p1*z_m1) * (1-d_p2*z_m1)  );
tf_IL_V_z = Kd * w_r^2*C * z_m1*(1-z_m1) / ( (1-d_p1*z_m1) * (1-d_p2*z_m1)  );
tf_dVUCdt_V_z = Kd * w_r^2 * z_m1*(1-z_m1) / ( (1-d_p1*z_m1) * (1-d_p2*z_m1)  );
tf_VUC_V_z = Kb * w_r^2 * z_m1*(1-d_z*z_m1) / ( (1-d_p1*z_m1) * (1-d_p2*z_m1)  );

% % the following built up transfer functions do not work because of
% % MATLAB's inability to simplify the transfer functions correctly
% % minreal also does not help
% tf2_delIL_V_z = tf_dILdt_V_z * Kd * z_m1 * (1-z_m1)/(1-d_z2*z_m1);
% tf2_IL_V_z = tf2_delIL_V_z / (1-z_m1);
% tf2_dVUCdt_V_z = tf2_IL_V_z / C;
% tf2_VUC_V_z = tf2_dVUCdt_V_z * Kb/Kd * (1-d_z*z_m1)/(1-z_m1);

% cancel matching roots in numerator and denominator
% verified behavior for existing values - must be verified after every
% change in parameters
tf_dILdt_V_z = minreal(tf_dILdt_V_z);
tf_delIL_V_z = minreal(tf_delIL_V_z);

tf_IL_V_z = zpk(tf_IL_V_z); % using this makes matlab's pole cancellation work when designing the controller - arbitrary behavior!
tf_IL_V_z = minreal(tf_IL_V_z);

tf_dVUCdt_V_z = minreal(tf_dVUCdt_V_z);

tf_VUC_V_z =  zpk(tf_VUC_V_z); % using this makes matlab's pole cancellation work when designing the controller - arbitrary behavior!
tf_VUC_V_z =  minreal(tf_VUC_V_z);

% % minreal for built up transfer functions
% tf2_delIL_V_z = minreal(tf2_delIL_V_z);
% tf2_IL_V_z = minreal(zpk(tf2_IL_V_z));
% tf2_dVUCdt_V_z = minreal(tf2_dVUCdt_V_z);
% tf2_VUC_V_z =  minreal(zpk(tf2_VUC_V_z));

%% save workspace data
save me547_based_model_v5_saved_state;