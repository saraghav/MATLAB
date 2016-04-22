% Problem 4

n = 100000;

p1 = 0.5;
p2 = 0.5;
phi = p1 - p2;
size = 1:1:1000;

n_range = double(int64(logspace(1,5,10)));
prob_estimates = zeros(1,length(n_range));

phi_hat_list = zeros(1, length(size));

for j=1:length(n_range)
    n = n_range(j)
    phi_hat_list = zeros(1, length(size));
    for i=size
        phi_hat_list(i) = (binornd(n,p1) - binornd(n,p2))/n;
    end
    thresh = 0.01;
    count = length(find( abs(phi_hat_list-phi) > thresh ));
    total = length(phi_hat_list);
    estimate = double(count)/double(total);
    prob_estimates(j) = estimate;
end

figure(1); hold on; grid on; grid minor;
plot(n_range, prob_estimates, 'LineWidth', 3);
xlabel('Number of People');
ylabel('Monte Carlo Estimate of $\hat{\phi}$');