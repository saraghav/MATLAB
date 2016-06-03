% load parameters
load me547_based_PI_controller_v3_saved_state;

%% command and response

% % step command
% ILcommand_z = 250*z_m1^2 / (1-z_m1);
% Vinit = 0;
% z2_m1 = z2_pow(1,-1); % z^-1, at Ts2=0.01s
% % VUCcommand_z = (Vinit + z2_pow( [ones(1,5) zeros(1,10) -ones(1,1) zeros(1,4)], -10-2*[(0:10:190)] ) ) /(1 - z2_m1);
% VUCcommand_z = (Vinit + z2_pow([0 3 3 -3 -3 0], [0 -1 -2 -10 -11 -12]) ) /(1 - z2_m1);

% double step command
% command_length = 50;
% command_transient = [0*ones(1,2) 250*ones(1,10) 500*ones(1,10)];
% ILcommand_z = z_pow([command_transient command_transient(end)*ones(1,command_length-length(command_transient))], (0:1:command_length-1)*-1) + command_transient(end)*z_m1^(command_length)/(1-z_m1);

% % step ramp up command
% command_length = 50;
% command_transient = 0:1:10;
% ILcommand_z = z_pow([command_transient command_transient(end)*ones(1,command_length-length(command_transient))], (0:1:command_length-1)*-1) + command_transient(end)*z_m1^(command_length)/(1-z_m1);
% % cancel matching roots in numerator and denominator
% % verified behavior for existing values - must be verified after every
% % change in parameters
% ILcommand_z = minreal(ILcommand_z);

% bidirectional current command
% ILcommand_z = z_pow( [2*ones(1,5) zeros(1,20) -1*ones(1,14) zeros(1,20)  1*ones(1,4)], -2-20*[(0:10:620)] ) /(1 - z_m1);
% ILcommand_z = z_pow( [0 50 100 50 -50 -100 -50], [0 -2 -10 -20 -4000 -4020 -4030] ) / ( 1 - z_m1 );
% 
% tf_IL_ILcommand_z = Gc_IL_z*tf_IL_V_z/(1+Gc_IL_z*tf_IL_V_z);
% % cancel matching roots in numerator and denominator
% % verified behavior for existing values - must be verified after every
% % change in parameters
% tf_IL_ILcommand_z = minreal(tf_IL_ILcommand_z);
% tf_IL_ILcommand_z = tf(tf_IL_ILcommand_z); % using this makes matlab's pole cancellation work when designing the controller - arbitrary behavior!
%                                            % NOTE: this works only when tf() is used AFTER minreal()
% 
% IL_z = tf_IL_ILcommand_z * ILcommand_z;


%% simulation
Vinit = 10;
Vbat = 48;

command_length = 20000;
sim_time_array = (0:command_length)*Ts;
u_sim = zeros(1,length(sim_time_array));
u_sim(1) = 1;

command_length = 500;
sim_time_array2 = (0:command_length)*Ts2;
u_sim2 = zeros(1,length(sim_time_array2));
u_sim2(1) = 1;

ILcommand_z = z_pow( [0 10 -5 -10], [0 -700 -800 -5000] ) / ( 1 - z_m1 );

return;

tf_response_z = ILcommand_z * tf_IL_ILcommand_z;
tf_response_z = minreal(zpk(tf_response_z));

% [IL_t, t] = lsim(IL_z,u_sim,sim_time_array);
% [Vuc_t, t] = lsim(Vuc_z,u_sim,sim_time_array);
% [V_t, t] = lsim(V_z,u_sim,sim_time_array);
% [ILstar_t, t] = lsim(ILstar_z,u_sim,sim_time_array);
% lsim(VUCcommand_z,u_sim2,sim_time_array2);

[IL_t, t] = lsim(tf_response_z,u_sim,sim_time_array);
[cmd_t, t] = lsim(ILcommand_z,u_sim,sim_time_array);
% u_sim = ones(1, length(sim_time_array));
% u_sim(10:500) = ones(1,length(10:500))*10;
% u_sim(500:5000) = ones(1,length(500:5000))*70;
% lsim(tf_IL_ILcommand_z,u_sim,sim_time_array);

%% plots

p=1;
figure(p); p=p+1;
stairs(t,IL_t,'b','LineWidth',2);
grid on; grid minor; hold on;
stairs(t,cmd_t,'r');
legend('I_L(t)', 'I_L_cmd(t)');

% figure(p); p=p+1;
% stairs(t,V_t,'r','LineWidth',2);
% % stem(t,IL_t,'r');
% legend('V(t)');
% grid on; grid minor; hold on;