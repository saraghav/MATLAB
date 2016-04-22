% Stochastic Gradient Descent Analysis
clear; clc; close all; figure_no = 1;

% data generation
p = 50;
s = 20;

% n_max = round(s*log(1000)/10 + 0.5)*10;
% n_list = round(linspace(10,n_max,7));
n_list = 1000;

w = zeros(p, 1);
sparse_values = rand(s,1) + 10*randn(s,1);
sparse_values_indices = randi(p,s,1);
w(sparse_values_indices) = sparse_values;

x_min = -1;
x_max = +1;

%% SGD iterations

for n=n_list
    disp('Generating data set');
    
    rep_max = 1;
    for rep=1:rep_max
        
        noise_observations = 0.5*randn(n,1);
        x = (x_max-x_min)*rand(n,p) + x_min;
        y_continuous = x * w + noise_observations;
        y = 2*(y_continuous>=0) - 1;
        
%         figure(figure_no); figure_no=figure_no+1; hold on; grid on; grid minor;
%         plot(y / max(y));
%         plot(2*(y>=0)-1);
        
%         max_eigenvalue = max(eig(x'*x));
%         step_size = (2/3)/(max_eigenvalue);
        
        iter_max = 10000;
        w_k = zeros(p,1);
        for iter=1:iter_max
            step_size = 1/sqrt(iter);
            w_km1 = w_k;
            w_k = SGD_iteration(y, x, w_km1, step_size);
        end
        
    end
end