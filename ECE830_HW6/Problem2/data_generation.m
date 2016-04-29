% data generation 1 for neural networks
clear; clc; close all;

basis_id = 1;
data_set_id = 2;

basis_filename = strcat('basis_', num2str(basis_id));
load(basis_filename);

n_training = 5000;
n_testing = 5000;

training_data = mvnrnd(mu, sigma, n_training);
testing_data = mvnrnd(mu, sigma, n_testing);

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

figure(1); hold on; grid on; grid minor;
for i=1:p
    histogram(training_data(:,i), 'Normalization', 'pdf');
end