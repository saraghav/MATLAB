% fss controller design v1
% me547_based_model_v5;
% clear; close all; clc;
load me547_based_model_v5_saved_state;

tf_TWA = tf([Ts 0], [1 -1], Ts);
tf_TWA2 = tf([Ts2 0], [1 -1], Ts2);
p=1;

% % Pole Zero Plot of IL(z)/V(z)
% figure(p); p=p+1;
% pzmap(tf_IL_V_z);
% grid on; grid minor; zgrid; grid on; grid minor;
% return;

%% PI Controller: Current Loop
fc1 = 10;
wc1 = 2*pi*fc1;
zpc1 = exp(-wc1*Ts);

Ra = 0.08; % initial dummy value; tuned value assigned below
Ea = 2; % initial dummy value; tuned value assigned below
% Km = Ra+Ea*Ts;
% d_z5 = 1/(1 + Ea/Ra*Ts);
Km = 1;
d_z5 = 0.985;

% % Gc_IL_z = zpk(Ra, 1, Ts); % For P Control
% Gc_IL_z = zpk([d_z5],[1],Km,Ts); % For PI Control
% 
% figure(p); p=p+1;
% tf_Gc_IL_t_IL_V_z = Gc_IL_z * tf_IL_V_z;
% tf_Gc_IL_t_IL_V_z = minreal(tf_Gc_IL_t_IL_V_z);
% fig1 = rlocusplot(tf_Gc_IL_t_IL_V_z, 0:1e-4:1);
% figopts = getoptions(fig1);
% figopts.Title.String = 'Current Loop Tuning (Ra, Ea?)';
% figopts.FreqUnits = 'Hz';
% figopts.Grid = 'on';
% figopts.XLim = {[0.9 1.01]};
% figopts.YLim = {[-0.5e-1 0.5e-1]};
% setoptions(fig1,figopts);
% h = findobj(gcf,'type','line'); set(h,'linewidth',3);
% 
% [K_c1, poles_c1] = rlocfind(Gc_IL_z * tf_IL_V_z, 0.94);
% 
% A = [  1-1/d_z5  Ts  ;  1  Ts  ];
% B = [  0  ;  K_c1  ];
% solution = A\B;
% Ra = solution(1);
% Ea = solution(2);
% Ra,Ea
% return;

% the desired pole does not fall on the root locus at all
% another approach to approximately cancel the zero at z=1 is taken
% for this, the proportional gain (Ra) used is 1
% Ra =  0.1243; % Did not work. Proportional gain was too high and caused noise, when pole was placed at 0.9
% Ea = 6.2776;
% for fastest closed-loop pole at z=0.94
Ra = 0.0560;
Ea = 4.2622;
Km = Ra+Ea*Ts;
d_z5 = 1/(1 + Ea/Ra*Ts);
% Gc_IL_z = zpk(Ra, 1, Ts); % For P Control
Gc_IL_z = zpk([d_z5],[1],Km,Ts); % For PI Control

tf_IL_ILcommand_z = Gc_IL_z*tf_IL_V_z / (1+Gc_IL_z*tf_IL_V_z);
tf_IL_ILcommand_z = minreal(tf_IL_ILcommand_z);


tf_IL_Dynamic_Stiffness = 1/tf_IL_V_z + Gc_IL_z;
tf_IL_Dynamic_Stiffness = minreal(tf_IL_Dynamic_Stiffness);

tf_IL_Command_Tracking = tf_IL_ILcommand_z;

%% PI Controller: Voltage Loop

% USES PI CURRENT AND P VOLTAGE CONTROLLER

% the following values have been estimated by approximating pole
% cancellation in the c2d(tf_IL_ILcommand_z) transfer function
Kel1 = 820.96;
ael1 = 812.6;

Kf = ( ael1*Ts2 - 1 + exp(-ael1*Ts2) ) / ael1;
Kg = Kel1/ael1*Kf;
d_z3 = (1 - exp(-ael1*Ts2) - ael1*Ts2*exp(-ael1*Ts2) ) / ( ael1*Ts2 - 1 + exp(-ael1*Ts2) ) ;
d_p3 = exp(-ael1*Ts2);

tf2_VUC_ILcommand_z = zpk( [-d_z3], [1 d_p3], (1/C * Kg), Ts2);

Kp_vc = 1;
Gc_VUC_z = Kp_vc;

% Integral controller below. Not used.
Ki_vc = 0;
% d_z4 = 1/(1 + Ki_vc/Kp_vc*Ts2);
% Kh = (Kp_vc+Ki_vc*Ts2);
% Gc_VUC_z = zpk( [d_z4], [1], Kh, Ts2);

% figure(p); p=p+1;
% fig1 = rlocusplot(Gc_VUC_z * tf2_VUC_ILcommand_z, 0:1:400);
% figopts = getoptions(fig1);
% figopts.Title.String = 'Voltage Loop Tuning (Ga)';
% figopts.FreqUnits = 'Hz';
% figopts.Grid = 'on';
% setoptions(fig1,figopts);
% h = findobj(gcf,'type','line'); set(h,'linewidth',3);

% final tuning
Kp_vc = 10;
Gc_VUC_z = Kp_vc;

% Integral controller below. Not used.
Ki_vc = 0;
% d_z4 = 1/(1 + Ki_vc/Kp_vc*Ts2);
% Kh = (Kp_vc+Ki_vc*Ts2);
% Gc_VUC_z = zpk( [d_z4], [1], Kh, Ts2);

tf2_VUC_VUCcommand_z = Gc_VUC_z*tf2_VUC_ILcommand_z/(1 + Gc_VUC_z*tf2_VUC_ILcommand_z);
tf2_VUC_VUCcommand_z = minreal(tf2_VUC_VUCcommand_z);



%% save workspace data
save me547_based_PI_controller_v3_saved_state;