% Problem 9
close all;
load lidar_blur;
sd = 1e-2;
covariance_noise = sd^2 * eye(256);
I = eye(256);

% generate w
w = zeros(256,1);
impulse_indices = [206 87 150 84 192];
impulse_values = [4 6 10 22 0.6]/10;
w(impulse_indices) = impulse_values;

% generate noise
eps = sd*randn(256,1);

% simulate
Xw = X*w;
y = Xw + eps;

% MLE
w_MLE = (X'*X) \ (X'*y);

% Bayesian
prior_mu_w = zeros(256,1);
prior_sd = 1e26;
prior_covariance_w = prior_sd^2 * eye(256);
w_PM = (X'*X + (sd^2)/(prior_sd^2)*I) \ (X'*y);

% plot
plot_ylim = [-1 3];

figure(1);
subplot(3,1,1); hold on; grid on; grid minor;
plot(w, 'LineWidth', 2);
xlim([0 256]); ylim(plot_ylim);
ylabel('Ideal LIDAR Signal');
subplot(3,1,2); hold on; grid on; grid minor;
plot(Xw, 'LineWidth', 2);
xlim([0 256]); ylim(plot_ylim);
ylabel('Blurred LIDAR Signal');
subplot(3,1,3); hold on; grid on; grid minor;
plot(y, 'LineWidth', 2);
xlim([0 256]); ylim(plot_ylim);
ylabel('Observerd LIDAR Signal');

figure(2); hold on; grid on; grid minor; legend_array = {};
plot(w_MLE, 'LineWidth', 2); legend_array = [legend_array 'MLE LIDAR Signal'];
plot(w_PM, 'LineWidth', 2); legend_array = [legend_array 'PM LIDAR Signal'];
plot(w, 'LineWidth', 2); legend_array = [legend_array 'Ideal LIDAR Signal'];
xlim([0 256]); ylim(plot_ylim);
legend(legend_array{:});
xlim([70 100]);