% basis generation for data
clear; close all; clc;

basis_id = 2;

p = 6;
mu = mvnrnd(zeros(p,1), 100*eye(p)); % 1xp matrix for means
mu = mu'; % transpose to make column vector

foo_mat = mvnrnd(zeros(p,1), eye(p), p); % pxp matrix for covariance
sigma = foo_mat' * foo_mat;
covar_thresh = 1;
sigma = sigma .* (abs(sigma) >= covar_thresh);

filename = strcat('basis_', num2str(basis_id));
save(filename);

mu
sigma