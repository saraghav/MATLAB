function visualize(X,Y,U)
    close all;
    
    [Y_shortest_distance, ~, ~] = assign_customer_to_store(X, Y);
    [U_shortest_distance, ~, ~] = assign_customer_to_store(X, U);
    won_customers = U_shortest_distance < Y_shortest_distance;
    shared_customers = (U_shortest_distance == Y_shortest_distance);
    lost_customers = ~(won_customers | shared_customers);
    
    figure(1); legend_list = {};
    hold on; grid on; grid minor;
%     plot(X(:,1), X(:,2), '.', 'MarkerSize', 1); legend_list = [legend_list 'customers'];
    if sum(won_customers) > 0
        plot(X(won_customers,1), X(won_customers,2), 'g.', 'MarkerSize', 5); legend_list = [legend_list 'won customers'];
    end
    if sum(shared_customers) > 0
        plot(X(shared_customers,1), X(shared_customers,2), 'b.', 'MarkerSize', 5); legend_list = [legend_list 'won customers'];
    end
    if sum(lost_customers) > 0
        plot(X(lost_customers,1), X(lost_customers,2), 'r.', 'MarkerSize', 5); legend_list = [legend_list 'lost customers'];
    end
    plot(Y(:,1), Y(:,2), 'x', 'MarkerSize', 10); legend_list = [legend_list 'competition'];
    plot(U(:,1), U(:,2), 'o', 'MarkerSize', 10); legend_list = [legend_list 'my stores'];
    legend(legend_list);
    xlim([-10 110]);
    ylim([-10 110]);
end