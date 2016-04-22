clear; close all;

%% Photon Counting Sensor

PCS_P_FA_list = [];
PCS_P_D_list = [];

L0 = 10;
L1 = 20;

for k_t = 0:1:50
    temp1 = 0;
    temp2 = 0;
    for k=0:k_t
        temp1 = temp1 + exp(-L0) * L0^k / factorial(k);
        temp2 = temp2 + exp(-L1) * L1^k / factorial(k);
    end
    P_FA = 1 - temp1;
    P_D = 1 - temp2;
    PCS_P_FA_list = [PCS_P_FA_list P_FA];
    PCS_P_D_list = [PCS_P_D_list P_D];
end

%% Light Intensity Sensor

LIS_P_FA_list = [];
LIS_P_D_list = [];

v = 10;
theta0 = 1;
theta1 = 2;

for t = 0:1:50
    temp1 = 0;
    temp2 = 0;
    
    P_FA = 1 - gammainc(t/theta0, v);
    P_D = 1 - gammainc(t/theta1, v);
    
    LIS_P_FA_list = [LIS_P_FA_list P_FA];
    LIS_P_D_list = [LIS_P_D_list P_D];
end


%% ROC Curves
figure(1); hold on; grid on; grid minor;
plot(PCS_P_FA_list, PCS_P_D_list, 'LineWidth', 3);
plot(LIS_P_FA_list, LIS_P_D_list, 'LineWidth', 3);
xlim([0 1]); ylim([0 1]);
xlabel('P_{FA} - Probability of False Alarm');
ylabel('P_{D} - Probability of Detection');
legend('Photon Counting Sensor', 'Light Intensity Sensor');