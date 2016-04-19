function J = calculate_J(X, Y, U)

[Y_shortest_distance, ~, Y_number_of_stores] = assign_customer_to_store(X, Y);
[U_shortest_distance, ~, U_number_of_stores] = assign_customer_to_store(X, U);

won_customers = U_shortest_distance < Y_shortest_distance;
J_wins = sum(won_customers);
shared_customers = (U_shortest_distance == Y_shortest_distance);
J_shares = sum( U_number_of_stores(shared_customers) ./ ( U_number_of_stores(shared_customers) + Y_number_of_stores(shared_customers) ) );
J = J_wins + J_shares;