% compressed sensing
clear; clc; close all;
mode = 'load';
filename = 'test_data_0.mat';

%% data
if strcmp(mode,'load') && exist(filename, 'file')
    disp(['Loading data from ' filename]);
    load(filename);
elseif strcmp(mode,'generate')
    disp('Generating data set');
    p = 1000;
    s = 10;
    n = 10;

    w = zeros(p, 1);

    sparse_values = rand(s,1) + 10*randn(s,1);
    sparse_values_indices = randi(p,s,1);
    w(sparse_values_indices) = sparse_values;

    x = randn(p,n);
    y = x' * w;
    L = 2 * sum(sum(x.^2)); % Lipschitz constant
    
    if ~exist(filename, 'file')
        save(filename);
    end
end

%% algorithm
w_history = {};

w_0 = zeros(p,1);

iter = 1;
iter_max = 100000;
w_k = w_0;
thresh = 1e-7;
while iter <= iter_max
    t = 1/L;
    
    w_km1 = w_k;
    w_k = prox_t(y, x, w_km1, t);
    w_history{iter} = w_k;
    
    if norm(w_k - w_km1) <= thresh
        disp('Improvement below threshold');
        break;
    end
    iter = iter+1;
end
if iter > iter_max
    disp('Iteration limit');
end

%% plots
p = 1;
figure(p); p=p+1; hold on; grid on; grid minor; legend_list = {};
plot(w); legend_list = [legend_list 'w^*'];
plot(w_k); legend_list = [legend_list 'w_k'];
legend(legend_list{:});

metrics = horzcat(sparse_values, w_k(sparse_values_indices));
metrics = horzcat(metrics, metrics(:,2)-metrics(:,1));
disp('METRICS (w*, w_k, w_k-w*):');
disp(metrics);