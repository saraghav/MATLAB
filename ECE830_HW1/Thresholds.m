% Deciding threshold
clear; close all;

%% PCS

k_t_list = 0:1:10;
P_miss_list = [];
P_FA_list = [];

L0 = 10;
L1 = 20;

for k_t = k_t_list
    temp1 = 0;
    P_miss = 0;
    for k = 0:k_t
        temp1 = temp1 + exp(-L0) * L0^k / factorial(k);
        P_miss = P_miss + exp(-L1) * (L1)^k / factorial(k);
    end
    P_FA = 1 - temp1;
    P_miss_list = [P_miss_list P_miss];
    P_FA_list = [P_FA_list P_FA];
end

figure(1); hold on; grid on; grid minor;
plotyy(k_t_list, P_miss_list, k_t_list, P_FA_list);
legend('P_{miss}', 'P_{FA}');

%% LIS

t_list = 0:1:10;
P_miss_list = [];
P_FA_list = [];

v = 10;
theta0 = 1;
theta1 = 2;

for t = t_list
    P_miss = gammainc(t/theta1, v);
    P_FA = 1 - gammainc(t/theta0, v);
    
    P_miss_list = [P_miss_list P_miss];
    P_FA_list = [P_FA_list P_FA];
end

figure(2); hold on; grid on; grid minor;
plotyy(t_list, P_miss_list, t_list, P_FA_list);
legend('P_{miss}', 'P_{FA}');