% spectrum plots

n_for_plot = 70;
l_for_plot = 60;

a = w_star_history{n_for_plot}{1}{l_for_plot};
b = w_est_history{n_for_plot}{1}{l_for_plot};
figure(1); hold on; grid on; grid minor;
plot(a, 'LineWidth', 3);
plot(b, 'LineWidth', 3);
h_legend = legend('w^*','w^{(k)}');

set(h_legend,'FontSize',14);
set(h_legend,'Location','Northeast');
xlabel('w');
ylabel('j');