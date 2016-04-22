% data generation 1 for neural networks
clear; clc; close all;

basis_id = 2;
data_set_id = 2;

basis_filename = strcat('basis_', num2str(basis_id));
load(basis_filename);

n_training = 5000;
n_testing = 5000;

w_training = mvnrnd(1:r, 10*eye(r), n_training);
w_testing = mvnrnd(1:r, 10*eye(r), n_testing);

training_data = w_training * V_star;
testing_data = w_testing * V_star;

for i=1:p
    minval = min(training_data(:,i));
    maxval = max(training_data(:,i));
    training_data(:,i) = (training_data(:,i) - minval) / (maxval - minval);
    
    minval = min(testing_data(:,i));
    maxval = max(testing_data(:,i));
    testing_data(:,i) = (testing_data(:,i) - minval) / (maxval - minval);
end

filename = strcat('data_set_', num2str(data_set_id));
save(filename);

return;

%% plot data

figure(1); clf;
hold on; grid on; grid minor;
for i=1:p
%     subplot(3,2,i);
    histogram(training_data(:,i), 'Normalization', 'pdf');
end