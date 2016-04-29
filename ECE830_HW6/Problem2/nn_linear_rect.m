% Autoencoder neural network with linear rectification
clear; close all; clc;

data_set_id = 2;
data_set_filename = strcat('data_set_', num2str(data_set_id));
load(data_set_filename);

M = 4;
n_training_examples = size(training_data,1);
n_testing_examples = size(testing_data,1);

debug_mode = 0;

%% training phase
disp('training phase');

% p = 6, M = 4
% W matrix is of size (p+1) x M
W_0 = 2*rand(p+1, M)-1; % to make the weights in (-1,1) randomly
W_0 = W_0 / 100;
% V matrix is of size (M+1) x p
V_0 = 2*rand(M+1, p)-1; % to make the weights in (-1,1) randomly
V_0 = V_0 / 100;

% alpha_t = 1e-3;
% k_alpha_max = 2, k_alpha_min = 1
k_alpha = 1.5;

f_best = Inf;

iter_max = 100000;
W_k = W_0;
V_k = V_0;
for iter=1:iter_max
    alpha_t = k_alpha/sqrt(iter);
    
    f_k = nn_linear_mse(W_k, V_k, training_data);
    if f_k < f_best
        W_best = W_k;
        V_best = V_k;
        f_best = f_k;
    end
    
    W_km1 = W_k;
    V_km1 = V_k;
    
    i_t = randi(n_training_examples);
    x = training_data(i_t,:)';
    x_i_t = [ x ; 1 ];
    h_i_t = [ W_km1' * x_i_t ; 1 ];
    xhat_i_t = V_km1' * h_i_t;
    
    delta = xhat_i_t - x;
    V_prime = V_km1(1:end-1,:); % exclude last row; constant term weights
    gamma = V_prime * delta;
    
    V_k = V_km1 - alpha_t * h_i_t * delta';
    W_k = W_km1 - alpha_t * x_i_t * gamma';
    
    if debug_mode == 1
        V_k
        W_k
        pause
    end
    
    V_k_isinf = max(max(isinf(V_k)));
    W_k_isinf = max(max(isinf(W_k)));
    if V_k_isinf || W_k_isinf
        iter
        disp('Inf encountered');
        return
    end
    
    V_k_isnan = max(max(isnan(V_k)));
    W_k_isnan = max(max(isnan(W_k)));
    if V_k_isnan || W_k_isnan
        iter
        disp('NaN encountered');
        return
    end
end

%% testing phase
disp('testing phase');

W_nn = W_best;
V_nn = V_best;
xhat_testing_data = zeros(size(testing_data));
for example=1:n_testing_examples
    x = testing_data(example,:)';
    x_nn = [ x ; 1 ];
    h_nn = [ W_nn' * x_nn ; 1 ];
    xhat_nn = V_nn' * h_nn;
    
    xhat_testing_data(example, :) = xhat_nn';
end

mean_squared_error = mse(xhat_testing_data - testing_data);

mean_squared_error

return;

%% visualize data
close all;

figure(1); clf;
hold on; grid on; grid minor;
for i=1:p
%     figure(i); clf;
%     hold on; grid on; grid minor;
%     plot(testing_data(:,i));
%     plot(xhat_testing_data(:,i));
%     plot(xhat_testing_data(:,i) - testing_data(:,i));

    subplot(3,2,i);
    histogram( (xhat_testing_data(:,i) - testing_data(:,i))./testing_data(:,i)*100 );
    grid on; grid minor;
    xlabel('error');
    ylabel('count');
    title(strcat(('x_'), num2str(i)));
    xlim([-100 100]);
end