% Problem 9
close all;
load sevens;
load mean;

% PCA and dimensionality reduction
[coeff, score, latent] = pca(d');
n_dim_subspace = 40;
X = coeff(:,1:n_dim_subspace);

distorted_image = poissrnd(mu);
y = reshape(distorted_image, 784, 1);

% Possion Estimator
w_hat_poisson = glmfit(X,y,'poisson','constant','off');
y_hat_poisson = exp(X*w_hat_poisson);
viewimage(y,1);
viewimage(y_hat_poisson,1);

% Gaussian Estimator
w_hat_gaussian = (X'*X)\X'*y;
y_hat_gaussian = X*w_hat_gaussian;
viewimage(y_hat_gaussian,1);

% Original Image
viewimage(mu,1);

%% variance plot

figure(1); hold on; grid on; grid minor;
subplot(1,2,1);
plot(latent, 'LineWidth', 3); hold on; grid on; grid minor;
xlim([0 100]);
subplot(1,2,2);
plot(latent/latent(1)*100, 'LineWidth', 3); hold on; grid on; grid minor;
xlim([0 100]);