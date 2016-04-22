% SGD experimental
clear; close all; clc; figure_no = 1;
set(0,'defaulttextinterpreter','latex');
load SGD_data_n_1000;
animate = 0;

k_best = 0;
w_best = zeros(p,1);
f_best = empirical_risk_hinge(y,x,w_best);

% iter_max_list = 1000000;
iter_max_list = round(logspace(1,6,10));

w_best_history = zeros(length(iter_max_list), p);
training_set_error_history = zeros(length(iter_max_list),1);
testing_set_error_history = zeros(length(iter_max_list),1);

for index=1:length(iter_max_list)
    iter_max = iter_max_list(index)
    w_k = zeros(p,1);
    for iter=1:iter_max
        step_size = 1/sqrt(iter);

        w_km1 = w_k;
        w_k = SGD_iteration(y, x, w_km1, step_size);

        f_k = empirical_risk_hinge(y,x,w_k);
        if f_k < f_best
            f_best = f_k;
            w_best = w_k;
            k_best = iter;
        end

        if (iter==1 || mod(iter,1000)==0) && animate == 1
            figure(figure_no); clf; hold on; grid on; grid minor;
            plot(w); plot(w_k); pause(1e-1);
            if iter == 1
                pause(5);
            end
        end
    end
    
%     figure(figure_no); figure_no=figure_no+1; legend_list = {};
%     hold on; grid on; grid minor;
%     plot(w); legend_list = [legend_list 'w^*'];
%     plot(w_best); legend_list = [legend_list 'w_{best}'];
%     plot(w_k); legend_list = [legend_list 'w^{(k)}'];
%     legend(legend_list);

    y_hat = 2*(x*w_best >= 0) - 1;
    training_set_error = sum(y_hat ~= y);

%     training_set_error

    [y_hat_testing, y_star_testing] = run_test(w_best);
    testing_set_error = sum(y_hat_testing ~= y_star_testing);

%     testing_set_error

    w_best_history(index,:) = w_best';
    training_set_error_history(index) = training_set_error;
    testing_set_error_history(index) = testing_set_error;
end

return;

%% visualize

figure(figure_no); figure_no=figure_no+1; legend_list = {};
hold on; grid on; grid minor;
plot(iter_max_list, training_set_error_history, 'LineWidth', 3); legend_list = [legend_list 'training set error'];
plot(iter_max_list, testing_set_error_history, 'LineWidth', 3); legend_list = [legend_list 'hold out set error'];
h_legend = legend(legend_list{:});
set(h_legend,'FontSize',14);
h_xlabel = xlabel('number of iterations');
set(h_xlabel,'FontSize',14);
h_ylabel = ylabel('error (no. of examples misclassified)');
set(h_ylabel,'FontSize',14);

fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',14)