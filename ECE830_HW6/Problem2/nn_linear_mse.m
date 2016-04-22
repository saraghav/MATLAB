function mse_all_examples = nn_linear_mse(W, V, training_data)

N = size(training_data, 1);
x = horzcat(training_data, ones(N,1));
h_prime = x * W;
h = horzcat(h_prime, ones(N,1));
xhat = h * V;

mse_all_examples = mse(xhat-training_data);