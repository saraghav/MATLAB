% view analysis results
mean_sqr_error_matrix = zeros(length(n_list), length(lambda_list));

i = 1;
for n=n_list
    j = 1;
    for lambda=lambda_list
        mean_sqr_error = 0;
        for rep=1:rep_max
            w_star = w_star_history{n}{rep}{lambda};
            w_est = w_est_history{n}{rep}{lambda};
            sqr_error = norm(w_star-w_est);
            mean_sqr_error = mean_sqr_error + sqr_error;
            
            disp(['n = ' num2str(n) ', rep = ' num2str(rep) ', lambda = ' num2str(lambda)]);
            disp(['sqr_error = ' num2str(sqr_error, '%.3f')]);
        end
        mean_sqr_error = mean_sqr_error/rep_max;
        
        mean_sqr_error_matrix(i,j) = mean_sqr_error;
        j = j+1;
    end
    i = i+1;
end

figno = 1; set(0,'defaulttextinterpreter','latex');
figure(figno); figno=figno+1; hold on; grid on; grid minor; legend_list = {};
for i=1:length(lambda_list)
    plot(n_list, mean_sqr_error_matrix(:,i), 'LineWidth', 2);
    legend_list = [legend_list strcat('\lambda = ', num2str(lambda_list(i)))];
end

n_bound = s*log(1000);
plot([n_bound n_bound], [ min(min(mean_sqr_error_matrix)) max(max(mean_sqr_error_matrix))], '--', 'LineWidth', 3);

h_legend = legend(legend_list{:});
set(h_legend,'FontSize',14);
set(h_legend,'Location','Southwest');
xlabel('n');
ylabel('Squared Error');