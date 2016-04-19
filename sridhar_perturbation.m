% perturbation based approach
function main
    tic_main = tic;
    % load data
    data_set_dir = 'my_data_sets';
    data_set_id = '2';
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
    assignin('base','X',X);
    assignin('base','Y',Y);
    assignin('base','n',n);
    
    toc_main = toc(tic_main);
    toc_main
    
    visualize(X,Y,U_star);
end

function U_0 = find_initial_guess(X,Y,n)
    % existing stores
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
        n_chosen_stores = n_chosen_stores+p;
    end
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

function U_0 = find_initial_guess_3(X,Y,n)
    % use midpoint between farthest customer from each store
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
        my_store_location = 0.5*( X(which_customer,:) + Y(which_ref_store,:) );
        
        U_0(n_chosen_stores+1,:) = my_store_location;
        slack = slack - 1;
        n_chosen_stores = n_chosen_stores + 1;
    end
end

function U_0 = find_initial_guess_4(X,~,n)
    % use k-means    
    [~, U_0] = kmeans(X, n, 'Distance', 'cityblock');
end

function [U_k, J_k] = perturb(X, Y, n, max_iterations)
%     U_k = find_initial_guess(X,Y,n);
%     U_k = find_initial_guess_2(X,Y,n);
%     U_k = find_initial_guess_3(X,Y,n);
%     U_k = find_initial_guess_4(X,Y,n);
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
%     max_iterations = 100;
    max_iterations = 10;
    store_location = U_k(store, :);
    
%     % x axis
%     [U_opt_right, J_opt_right] = linear_search(X, Y, U_k, store, [store_location(1) 100], store_location(2), max_iterations);
%     [U_opt_left, J_opt_left] = linear_search(X, Y, U_k, store, [0 store_location(1)], store_location(2), max_iterations);
%     
%     % y axis
%     [U_opt_up, J_opt_up] = linear_search(X, Y, U_k, store, store_location(1), [store_location(2) 100], max_iterations);
%     [U_opt_down, J_opt_down] = linear_search(X, Y, U_k, store, store_location(1), [0 store_location(2)], max_iterations);

    % x axis
    [U_opt_right, J_opt_right] = contracting_search(X, Y, U_k, store, [store_location(1) 100], store_location(2), max_iterations);
    [U_opt_left, J_opt_left] = contracting_search(X, Y, U_k, store, [0 store_location(1)], store_location(2), max_iterations);
    
    % y axis
    [U_opt_up, J_opt_up] = contracting_search(X, Y, U_k, store, store_location(1), [store_location(2) 100], max_iterations);
    [U_opt_down, J_opt_down] = contracting_search(X, Y, U_k, store, store_location(1), [0 store_location(2)], max_iterations);
    
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
        parfor iter = 1:max_iterations
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
        parfor iter = 1:max_iterations
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

function [opt_U, opt_J] = contracting_search(X, Y, U_k, store, x, y, max_iterations)
    contract_depth = 3;
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
        parfor iter=1:max_iterations
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