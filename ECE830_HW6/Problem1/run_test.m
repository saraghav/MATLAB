function [y_hat_testing, y_star_testing] = run_test(w_best)

load SGD_data_n_1000_testing;

y_hat_testing = 2*(x*w_best >= 0) - 1;
y_star_testing = y;