function [shortest_distance, which_stores, number_of_stores] = assign_customer_to_store(X, S)

x_distance_to_stores = bsxfun(@minus, X(:,1), S(:,1)');
y_distance_to_stores = bsxfun(@minus, X(:,2), S(:,2)');
manhattan_distance_to_store = abs(x_distance_to_stores) + abs(y_distance_to_stores);
shortest_distance = min(manhattan_distance_to_store, [], 2); % min along each row
which_stores = bsxfun(@eq, shortest_distance, manhattan_distance_to_store);
number_of_stores = sum(which_stores, 2);