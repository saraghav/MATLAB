%% algorithm
clear; clc;
load testcase_1;

X_0 = zeros(n1,n2);

iter = 1;
iter_max = 10000;
X_k = X_0;
thresh = 1e-9;

lambda = 1e-1;

while iter <= iter_max
    t = 0.5;
    
    X_km1 = X_k;
    X_k = prox_t(M, X_km1, t, lambda);
    
    if 0 && norm(X_k - X_km1, 'fro') <= thresh
        disp('Improvement below threshold');
        break;
    end
    iter = iter+1;
end
if iter > iter_max
    disp('Iteration limit');
end

perc_err = (X_k - M_full) ./ (M_full) * 100;
perc_err_obs = perc_err .* (M ~= 0);
perc_err_est = perc_err .* (M == 0);
mse_alg = mse(X_k, M_full)