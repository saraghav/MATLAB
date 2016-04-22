function visualize2(X,Y,U)
    close all;
    
    [Y_shortest_distance, ~, ~] = assign_customer_to_store(X, Y);
    [U_shortest_distance, U_which_store, ~] = assign_customer_to_store(X, U);
    won_customers = U_shortest_distance < Y_shortest_distance;
    shared_customers = (U_shortest_distance == Y_shortest_distance);
    lost_customers = ~(won_customers | shared_customers);
    
    figure(1); legend_list = {};
    hold on; grid on; grid minor;
    if sum(shared_customers) > 0
        plot(X(shared_customers,1), X(shared_customers,2), 'b.', 'MarkerSize', 5); legend_list = [legend_list 'won customers'];
    end
    if sum(lost_customers) > 0
        plot(X(lost_customers,1), X(lost_customers,2), 'r.', 'MarkerSize', 5); legend_list = [legend_list 'lost customers'];
    end
    if sum(won_customers) > 0
        n = size(U,1);
        for store=1:n
            store_won_customers = and(U_which_store(:,store), won_customers);
            plot(X(store_won_customers,1), X(store_won_customers,2), '*', 'MarkerSize', 5); legend_list = [legend_list 'won customers'];
        end
    end
    plot(Y(:,1), Y(:,2), 'x', 'MarkerSize', 10, 'LineWidth', 3); legend_list = [legend_list 'competition'];
    plot(U(:,1), U(:,2), 'o', 'MarkerSize', 10, 'LineWidth', 2); legend_list = [legend_list 'my stores'];
    legend(legend_list);
    xlim([-10 110]);
    ylim([-10 110]);
end