% perturbation based approach
function sridhar
    warning('off','stats:kmeans:FailedToConverge');
    tic_main = tic;
    % load data
    load X; load Y; load n;

    N = size(X,1);
    if n > N
        n = N;
    end
    
    m = size(Y,1);
    
    if n <= 0 || N == 0
        % nothing to optimize for
        U_star = [];
        J_star = 0;
    elseif m == 0
        % monopoly
        U_star = [0 0];
        J_star = N;
    else
        max_iterations = 50;
        [U_star, J_star] = perturb(X, Y, n, max_iterations);
    end
    
    assignin('base','U_star',U_star);
    assignin('base','J_star',J_star);
    assignin('base','X',X);
    assignin('base','Y',Y);
    assignin('base','n',n);
    
    toc_main = toc(tic_main);
    disp( strcat('Runtime = ', num2str(round(toc_main), ' %d'), ' s' ));
end

function U_0 = find_initial_guess_2(X,Y,n)
    % use farthest customer from each store
    m = size(Y,1);
    
    [shortest_distance, which_stores, ~] = assign_customer_to_store(X,Y);
    customers_per_store = sum(which_stores);
    [~, sorted_indices] = sort(customers_per_store, 2, 'descend');
    
    U_0 = zeros(n,2);
    
    exclude_offset = max(2*max(shortest_distance) , 1);
    n_chosen_stores = 0;
    slack = n - n_chosen_stores;
    while slack > 0
        which_ref_store = sorted_indices( mod(n_chosen_stores,m)+1 );
        customers_to_ref_store = which_stores(:,which_ref_store);
        [~, which_customer] = max( shortest_distance - (~customers_to_ref_store) .* exclude_offset );
        my_store_location = X(which_customer,:);
        
        U_0(n_chosen_stores+1,:) = my_store_location;
        slack = slack - 1;
        n_chosen_stores = n_chosen_stores + 1;
    end
end

function U_0 = find_initial_guess_4(X,~,n)
    % use k-means    
    [~, U_0] = kmeans(X, n, 'Distance', 'cityblock');
end

function [U_best, J_best] = perturb(X, Y, n, max_iterations)
    % try with farthest point
    U_k = find_initial_guess_2(X,Y,n);
    J_k = calculate_J(X, Y, U_k);
    
    tic_perturb = tic;
    timeout = 0;
    
    for iter=1:max_iterations
        U_km1 = U_k;
        for store=1:n
            [U_k, J_k] = line_search(X, Y, U_k, store);
            if toc(tic_perturb)*(1+1/iter) >= 900
                timeout = 1;
                break;
            end
        end
        if U_km1 == U_k
            break;
        end
        if timeout == 1
            break;
        end
    end
    
    U_best = U_k;
    J_best = J_k;
    iter_so_far = iter;
    
    % try with k-means approach
    U_k = find_initial_guess_4(X,Y,n);
    J_k = calculate_J(X, Y, U_k);
    
    for iter=1:max_iterations
        U_km1 = U_k;
        for store=1:n
            [U_k, J_k] = line_search(X, Y, U_k, store);
            if toc(tic_perturb)*(1+1/(iter_so_far+iter)) >= 900
                timeout = 1;
                break;
            end
        end
        if U_km1 == U_k
            break;
        end
        if timeout == 1
            break;
        end
    end
    
    if J_k >= J_best
        U_best = U_k;
        J_best = J_k;
    end
end

function [U_best, J_best] = line_search(X, Y, U_k, store)
    max_iterations = 10;
    store_location = U_k(store, :);
    
    [x_range_all_pairs, y_range_all_pairs] = generate_all_pairs(store_location, [0 0], [100 100]);
    n_ranges = size(x_range_all_pairs,1);
    U_list = cell(n_ranges,1);
    J_list = zeros(n_ranges,1);
    
    for range = 1:n_ranges
        x_range = x_range_all_pairs(range,:);
        y_range = y_range_all_pairs(range,:);
        [U_list{range}, J_list(range)] = contracting_search(X, Y, U_k, store, x_range, y_range, max_iterations);
    end
      
    % pick best
    [J_best, best_index] = max(J_list);
    U_best = U_list{best_index};
end

function [x_range_all_pairs, y_range_all_pairs] = generate_all_pairs(coord, rect_ll, rect_ur)
    if all( and((coord > rect_ll) , (coord < rect_ur) ) )
        x_range_all_pairs = [
            rect_ll(1) coord(1)   ; % W
            coord(1)   rect_ur(1) ; % E
            coord(1)   coord(1)   ; % N
            coord(1)   coord(1)   ; % S
            rect_ll(1) coord(1)   ; % SW
            rect_ll(1) coord(1)   ; % NW
            coord(1)   rect_ur(1) ; % SE
            coord(1)   rect_ur(1) ; % NE
        ];
        y_range_all_pairs = [
            coord(2)   coord(2)   ; % W
            coord(2)   coord(2)   ; % E
            coord(2)   rect_ur(2) ; % N
            rect_ll(2) coord(2)   ; % S
            rect_ll(2) coord(2)   ; % SW
            coord(2)   rect_ur(2) ; % NW
            rect_ll(2) coord(2)   ; % SE
            coord(2)   rect_ur(2) ; % NE
        ];
    else
        x_range_all_pairs = [
            rect_ll(1) coord(1)   ; % SW
            rect_ll(1) coord(1)   ; % NW
            coord(1)   rect_ur(1) ; % SE
            coord(1)   rect_ur(1) ; % NE
        ];
        y_range_all_pairs = [
            rect_ll(2) coord(2)   ; % SW
            coord(2)   rect_ur(2) ; % NW
            rect_ll(2) coord(2)   ; % SE
            coord(2)   rect_ur(2) ; % NE
        ];
    end
end

function [opt_U, opt_J] = contracting_search(X, Y, U_k, store, x, y, max_iterations)
    contract_depth = 2;
    if length(x) == 2 && length(y) == 1
        x_grid = linspace(x(1), x(2), max_iterations);
        y_grid = y * ones(1,max_iterations);
    elseif length(x) == 1 && length(y) == 2
        x_grid = x * ones(1,max_iterations);
        y_grid = linspace(y(1), y(2), max_iterations);
    else
        x_grid = linspace(x(1), x(2), max_iterations);
        y_grid = linspace(y(1), y(2), max_iterations);
    end
    
    J_grid = zeros(size(x_grid));

    for depth = 1:contract_depth
        for iter=1:max_iterations
            x_iter = x_grid(iter);
            y_iter = y_grid(iter);
            
            new_coord = [x_iter y_iter];
            
            U_temp = U_k;
            U_temp(store,:) = new_coord;
            
            J_grid(iter) = calculate_J(X, Y, U_temp);
        end
        
        [opt_J, max_index] = max(J_grid);
        opt_U = U_k;
        opt_U(store, :) = [x_grid(max_index) y_grid(max_index)];
        
        if max_index == 1
            x_grid = linspace(x_grid(max_index), x_grid(max_index+2), max_iterations);
            y_grid = linspace(y_grid(max_index), y_grid(max_index+2), max_iterations);
        elseif max_index == max_iterations
            x_grid = linspace(x_grid(max_index-2), x_grid(max_index), max_iterations);
            y_grid = linspace(y_grid(max_index-2), y_grid(max_index), max_iterations);
        else
            x_grid = linspace(x_grid(max_index-1), x_grid(max_index+1), max_iterations);
            y_grid = linspace(y_grid(max_index-1), y_grid(max_index+1), max_iterations);
        end
    end
end

function [shortest_distance, which_stores, number_of_stores] = assign_customer_to_store(X, S)
    x_distance_to_stores = bsxfun(@minus, X(:,1), S(:,1)');
    y_distance_to_stores = bsxfun(@minus, X(:,2), S(:,2)');
    manhattan_distance_to_store = abs(x_distance_to_stores) + abs(y_distance_to_stores);
    shortest_distance = min(manhattan_distance_to_store, [], 2); % min along each row
    which_stores = bsxfun(@eq, shortest_distance, manhattan_distance_to_store);
    number_of_stores = sum(which_stores, 2);
end

function J = calculate_J(X, Y, U)
    [Y_shortest_distance, ~, Y_number_of_stores] = assign_customer_to_store(X, Y);
    [U_shortest_distance, ~, U_number_of_stores] = assign_customer_to_store(X, U);

    won_customers = U_shortest_distance < Y_shortest_distance;
    J_wins = sum(won_customers);
    shared_customers = (U_shortest_distance == Y_shortest_distance);
    J_shares = sum( U_number_of_stores(shared_customers) ./ ( U_number_of_stores(shared_customers) + Y_number_of_stores(shared_customers) ) );
    J = J_wins + J_shares;
end

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
    plot(Y(:,1), Y(:,2), 'x', 'MarkerSize', 10); legend_list = [legend_list 'competition'];
    plot(U(:,1), U(:,2), 'o', 'MarkerSize', 10); legend_list = [legend_list 'my stores'];
    legend(legend_list);
    xlim([-10 110]);
    ylim([-10 110]);
end