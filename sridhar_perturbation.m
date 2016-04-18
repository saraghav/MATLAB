% perturbation based approach
function main
    tic_main = tic;
    % load data
    data_set_dir = 'my_data_sets';
    data_set_id = '3';
%     data_set_dir = 'prof_data_sets';
%     data_set_id = '1';
    files = {'X', 'Y', 'n'};
    for file_index=1:length(files)
        file = files{file_index};
        file_to_load = strcat(data_set_dir, '/', data_set_id, '/', file, '.mat');
        load(file_to_load);
    end
    clear file file_index file_to_load;

    N = size(X,1);
    if n > N
        n = N;
    end
    
    if n <= 0
        U_star = [];
        J_star = 0;
    else
        max_iterations = 100;
        [U_star, J_star] = perturb(X, Y, n, max_iterations);
    end
    
    assignin('base','U_star',U_star);
    assignin('base','J_star',J_star);
    
    toc_main = toc(tic_main);
    toc_main
    
    visualize(X,Y,U_star);
end

function U_0 = find_initial_guess(X,Y,n)
    m = size(Y,1);
    
    [~, which_stores, ~] = assign_customer_to_store(X,Y);
    customers_per_store = sum(which_stores);
    [~, sorted_indices] = sort(customers_per_store, 2, 'descend');
    
    U_0 = zeros(n,2);
    
    n_chosen_stores = 0;
    slack = n - n_chosen_stores;
    while slack > 0
        p = min(m, slack); % choose p stores
        U_0(n_chosen_stores+(1:p),:) = Y(sorted_indices(1:p), :);
        slack = slack - p;
    end
end

function [U_k, J_k] = perturb(X, Y, n, max_iterations)
    U_k = find_initial_guess(X,Y,n);
    J_k = calculate_J(X, Y, U_k);
    
    for iter=1:max_iterations
        U_km1 = U_k;
        for store=1:n
            [U_k, J_k] = line_search(X, Y, U_k, store);
        end
        if U_km1 == U_k
            disp('No more improvement');
            disp(iter);
            break;
        end
    end
end

function [U_best, J_best] = line_search(X, Y, U_k, store)
    max_iterations = 100;
    store_location = U_k(store, :);
    
    % x axis
    [U_opt_right, J_opt_right] = linear_search(X, Y, U_k, store, [store_location(1) 100], store_location(2), max_iterations);
    [U_opt_left, J_opt_left] = linear_search(X, Y, U_k, store, [0 store_location(1)], store_location(2), max_iterations);
    
    % y axis
    [U_opt_up, J_opt_up] = linear_search(X, Y, U_k, store, store_location(1), [store_location(2) 100], max_iterations);
    [U_opt_down, J_opt_down] = linear_search(X, Y, U_k, store, store_location(1), [0 store_location(2)], max_iterations);
    
    % pick best
    J_list = [J_opt_right, J_opt_left, J_opt_up, J_opt_down];
    [J_best, best_index] = max(J_list);
    if best_index == 1
        U_best = U_opt_right;
    elseif best_index == 2
        U_best = U_opt_left;
    elseif best_index == 3
        U_best = U_opt_up;
    elseif best_index == 4
        U_best = U_opt_down;
    end
end

function [opt_U, opt_J] = linear_search(X, Y, U_k, store, x, y, max_iterations)
    if length(x) == 2
        % search along x
        x_grid = linspace(x(1), x(2), max_iterations);
        J_grid = zeros(size(x_grid));
        for iter = 1:max_iterations
            x_iter = x_grid(iter);
            
            new_coord = [x_iter y];
            
            U_temp = U_k;
            U_temp(store,:) = new_coord;
            
            J_grid(iter) = calculate_J(X, Y, U_temp);
        end
        
        [opt_J, max_index] = max(J_grid);
        opt_U = U_k;
        opt_U(store, 1) = x_grid(max_index);
    else
        % search along y
        y_grid = linspace(y(1), y(2), max_iterations);
        J_grid = zeros(size(y_grid));
        for iter = 1:max_iterations
            y_iter = y_grid(iter);
            
            new_coord = [x y_iter];
            
            U_temp = U_k;
            U_temp(store,:) = new_coord;
            
            J_grid(iter) = calculate_J(X, Y, U_temp);
        end
        
        [opt_J, max_index] = max(J_grid);
        opt_U = U_k;
        opt_U(store, 2) = y_grid(max_index);
    end
end

function visualize(X,Y,U)
    close all;
    
    figure(1); legend_list = {};
    hold on; grid on; grid minor;
    plot(X(:,1), X(:,2), '.', 'MarkerSize', 1); legend_list = [legend_list 'customers'];
    plot(Y(:,1), Y(:,2), 'x', 'MarkerSize', 10); legend_list = [legend_list 'competition'];
    plot(U(:,1), U(:,2), 'o', 'MarkerSize', 10); legend_list = [legend_list 'my stores'];
    xlim([-10 110]);
    ylim([-10 110]);
end