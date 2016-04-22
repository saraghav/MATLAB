function w_t = SGD_iteration(y, x, w_tm1, alpha_t)

n_examples = length(y);
i_t = randi(n_examples);

x_i_t = x(i_t, :);
y_i_t = y(i_t);
p = length(x_i_t);
hinge_loss = max(0, 1 - y_i_t * (x_i_t * w_tm1));

% noisy unbiased subgradient
noise_subgradient = randn(p,1);
% noise_subgradient = zeros(p,1);
if hinge_loss > 0
    g = -y_i_t*x_i_t';
else
    g = zeros(p,1);
end
g_noisy_unbiased = g + noise_subgradient;

% calculate the subgradient
w_t = w_tm1 - alpha_t * g_noisy_unbiased;
% w_t = w_tm1 - alpha_t * g;
