% Autoencoder neural network with linear rectification
clear; close all; clc;

data_set_id = 2;
data_set_filename = strcat('data_set_', num2str(data_set_id));
load(data_set_filename);

M = 4;
n_training_examples = size(training_data,1);
n_testing_examples = size(testing_data,1);

% p = 6, M = 4
% W matrix is of size (p+1) x M
W_0 = 2*rand(p+1, M)-1; % to make the weights in (-1,1) randomly
W_0 = W_0 / 100;
% V matrix is of size (M+1) x p
V_0 = 2*rand(M+1, p)-1; % to make the weights in (-1,1) randomly
V_0 = V_0 / 100;

% k_alpha_max = 2, k_alpha_min = 1
k_alpha_list = [0.1 0.8 1 1.5 2];
rep_list = 1:5;
mse_history = zeros(length(k_alpha_list), length(rep_list));

for index = 1:length(k_alpha_list)
    index
    k_alpha = k_alpha_list(index);
    
    for rep = rep_list
        rep

        % training phase
        disp('training phase');

        iter_max = 100000;
        W_k = W_0;
        V_k = V_0;
        for iter=1:iter_max
            alpha_t = k_alpha/sqrt(iter);

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

        % testing phase
        disp('testing phase');

        W_nn = W_k;
        V_nn = V_k;
        xhat_testing_data = zeros(size(testing_data));
        for example=1:n_testing_examples
            x = testing_data(example,:)';
            x_nn = [ x ; 1 ];
            h_nn = [ W_nn' * x_nn ; 1 ];
            xhat_nn = V_nn' * h_nn;

            xhat_testing_data(example, :) = xhat_nn';
        end

        mean_squared_error = mse(xhat_testing_data - testing_data);
        
        mse_history(index,rep) = mean_squared_error;
        
    end % rep loop
end % k_alpha loop

return;

%% visualize data
close all;

figure(1); hold on; grid on; grid minor; legend_list = {};
plot(k_alpha_list, mean(mse_history')', '--', 'LineWidth' , 2); legend_list = [legend_list 'trend'];
plot(k_alpha_list, mse_history, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'red');
legend(legend_list{:});
xlabel('k_\alpha');
ylabel('MSE on the hold-out set');

fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',14)
