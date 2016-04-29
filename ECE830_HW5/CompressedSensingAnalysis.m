% compressed sensing
clear; clc; close all;

p = 1000;
s = 50;

n_max = round(s*log(1000)/10 + 0.5)*10;
n_list = round(linspace(10,n_max,7));
lambda_list = [1 20:20:120];

w_star_history = {};
w_est_history = {};
termination_code = {};

w = zeros(p, 1);
sparse_values = rand(s,1) + 10*randn(s,1);
sparse_values_indices = randi(p,s,1);
w(sparse_values_indices) = sparse_values;

for n=n_list
    disp('Generating data set');
    
    rep_max = 1;
    for rep=1:rep_max
        
        x = randn(p,n);
        y = x' * w;
        L = 2 * sum(sum(x.^2)); % Lipschitz constant
        
        w_0 = zeros(p,1);
        for lambda=lambda_list
            iter = 1;
            iter_max = 100000;
            w_k = w_0;
            thresh = 1e-7;
            while iter <= iter_max
                t = 1/L;

                w_km1 = w_k;
                w_k = prox_t(y, x, w_km1, t, lambda);

                if norm(w_k - w_km1) <= thresh
                    disp('Improvement below threshold');
                    termination_code{n}{rep}{lambda} = 0;
                    break;
                end
                iter = iter+1;
            end
            if iter > iter_max
                disp('Iteration limit');
                termination_code{n}{rep}{lambda} = 1;
            end
            
            w_star_history{n}{rep}{lambda} = w;
            w_est_history{n}{rep}{lambda} = w_k;
        end
        
    end
end


%% plots
% p = 1;
% figure(p); p=p+1; hold on; grid on; grid minor; legend_list = {};
% plot(w); legend_list = [legend_list 'w^*'];
% plot(w_k); legend_list = [legend_list 'w_k'];
% legend(legend_list{:});
% 
% metrics = horzcat(sparse_values, w_k(sparse_values_indices));
% metrics = horzcat(metrics, metrics(:,2)-metrics(:,1));
% disp('METRICS (w*, w_k, w_k-w*):');
% disp(metrics);