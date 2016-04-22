% solution
clear; close all; clc;

% load data
% data_set_dir = '.'; % for final submission
% data_set_id = ''; % for final submission
data_set_dir = 'my_data_sets';
data_set_id = '4';
files = {'X', 'Y', 'n'};
for file_index=1:length(files)
    file = files{file_index};
    file_to_load = strcat(data_set_dir, '/', data_set_id, '/', file, '.mat');
    load(file_to_load);
end
clear file file_index file_to_load;

N = size(X,1);
m = size(Y,1);

if n > N
    n = N;
end

%% calculate distances to competitors shops

x_distance_to_competitors = bsxfun(@minus, X(:,1), Y(:,1)');
y_distance_to_competitors = bsxfun(@minus, X(:,2), Y(:,2)');
manhattan_distance_to_competitors = abs(x_distance_to_competitors) + abs(y_distance_to_competitors);
customer_to_competition = min(manhattan_distance_to_competitors, [], 2); % min along each row

max_distance_bound = 400;
min_distance_bound = 1e-4 * min(customer_to_competition);

%% calculate the locations of our shops as a MILP

% % decision variables
% u_x = zeros(n,1); % dummy - to visualize the program
% u_y = zeros(n,1); % dummy - to visualize the program
% d_ij = zeros(2*n*N,1); % dummy - to visualize the program
% c_ij = zeros(n*N,1); % dummy - to visualize the program
num_variables = 2*n+2*N*n+N*n;

% % for customer j = 1:N
% % for shop i = 1:n
% %   u_xi = x(i)
% %   u_yi = x(n + i)
% %   d_xij = x(2*n + (j-1)*n + i)
% %   d_yij = x(2*n + N*n + (j-1)*n + i)
% %   c_ij = x(2*n + 2*N*n + (j-1)*n + i)
num_pairwise_constraint_types = 5;
num_customer_specific_constraint_types = 1;
num_pairwise_constraints = num_pairwise_constraint_types*N*n;
num_customer_specific_constraints = num_customer_specific_constraint_types*N;
num_constraints = num_pairwise_constraints + num_customer_specific_constraints;

% variable types and variable bounds
intcon = 2*n+2*N*n + (1:N*n); % offset + range of c_ij s
lb = zeros(num_variables,1);
ub = [
    100*ones(2*n,1) ;
    max_distance_bound*ones(2*N*n,1) ;
    ones(N*n,1) ;
];

% inequality constraints
A = zeros(num_constraints, num_variables);
b = zeros(num_constraints, 1);

constraint_offset = N*n;
constraint_types_list = 1:num_pairwise_constraint_types;
constraint_set_offset = constraint_offset*(constraint_types_list-1);

for j=1:N
    for i=1:n
        c_id = (j-1)*n + i;
        
        % constraint 1: u_xi - x_j <= d_xij
        c_index = constraint_set_offset(1) + c_id;
        A(c_index, [i, 2*n+(j-1)*n+i]) = [1, -1];
        b(c_index) = X(j, 1);
        
        % constraint 2: u_xi - x_j >= -d_xij
        c_index = constraint_set_offset(2) + c_id;
        A(c_index, [i, 2*n+(j-1)*n+i]) = [-1, -1];
        b(c_index) = -X(j,1);
        
        % constraint 3: u_yi - y_j <= d_yij
        c_index = constraint_set_offset(3) + c_id;
        A(c_index, [n+i, 2*n+N*n+(j-1)*n+i]) = [1, -1];
        b(c_index) = X(j,2);
        
        % constraint 4: u_yi - y_j >= -d_yij
        c_index = constraint_set_offset(4) + c_id;
        A(c_index, [n+i, 2*n+N*n+(j-1)*n+i]) = [-1, -1];
        b(c_index) = -X(j,2);
        
        % constraint 5: d_xij + d_yij + (max_distance_bound -
        %           customer_to_competition)*c_ij <= max_distance_bound
        c_index = constraint_set_offset(5) + c_id;
        A(c_index, [2*n+(j-1)*n+i, 2*n+N*n+(j-1)*n+i, 2*n+2*N*n+(j-1)*n+i]) = [1, 1, max_distance_bound-customer_to_competition(j)+min_distance_bound];
        b(c_index) = max_distance_bound;
    end
    
    % constraint 6: SUM c_ij <= 1 (no more than one shop services customer)
    c_index = num_pairwise_constraints + j;
    A(c_index, 2*n+2*N*n+(j-1)*n+(1:n)) = ones(1,n);
    b(c_index) = 1;
end

% equality constraints
Aeq = [];
beq = [];

% cost function
C = zeros(num_variables, num_variables);
d = zeros(num_variables, 1);
C(2*n+2*N*n+(1:N*n), 2*n+2*N*n+(1:N*n)) = speye(N*n);
d(2*n+2*N*n+(1:N*n)) = ones(N*n,1);

%% solve the MILP
lsqlin_options = optimoptions('lsqlin');
lsqlin_options.Algorithm = 'active-set';
lsqlin_options.MaxIter = 100000;

x0 = [];
% x0 = [
%     Y(:,1) ;
%     Y(:,2) ;
%     reshape(x_distance_to_competitors, [N*n,1]) ;
%     reshape(y_distance_to_competitors, [N*n,1]) ;
%     ones(N*n,1)
% ];

tic
[x,fval,exitflag,output] = lsqlin(C,d,A,b,Aeq,beq,lb,ub, x0, lsqlin_options);
toc

%% repurpose the output and plot the results
U = zeros(n,2);
for i=1:n
    U(i,:) = [x(i), x(n+i)];
end

figure(1); legend_list = {};
hold on; grid on; grid minor;
plot(X(:,1), X(:,2), '.', 'MarkerSize', 10);
plot(Y(:,1), Y(:,2), 'x', 'MarkerSize', 10);
plot(U(:,1), U(:,2), 'o', 'MarkerSize', 10);
xlim([-10 110]);
ylim([-10 110]);