% compare distances

x_distance_to_my_shops = bsxfun(@minus, X(:,1), U(:,1)');
y_distance_to_my_shops = bsxfun(@minus, X(:,2), U(:,2)');
manhattan_distance_to_my_shops = abs(x_distance_to_my_shops) + abs(y_distance_to_my_shops);
customer_to_my_shops = min(manhattan_distance_to_my_shops, [], 2); % min along each row
difference = customer_to_my_shops - customer_to_competition;

summary = horzcat(X, customer_to_competition, customer_to_my_shops, difference);
disp(summary);
fprintf('%e\n', summary(:,end));