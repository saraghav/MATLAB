% solution
clear; close all; clc;

% load data
% data_set_dir = '.'; % for final submission
% data_set_id = ''; % for final submission
data_set_dir = 'my_data_sets';
data_set_id = '2';
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
%     c_index = num_pairwise_constraints + j;
%     A(c_index, 2*n+2*N*n+(j-1)*n+(1:n)) = ones(1,n);
%     b(c_index) = 1;
end

% equality constraints
Aeq = [];
beq = [];

% cost function
f = zeros(num_variables, 1);
f(intcon) = -1;
% f(2*n+(1:2*N*n)) = 1e-5;

%% iterate over an LP to get better results
lp_options = optimoptions('linprog');

var_offset = 2*n+2*N*n;
var_unint_attempts_id = zeros(size(intcon));
max_lp_attempts = 10;
Aeq_iter = Aeq;
beq_iter = beq;
for lp_iter = 1:max_lp_attempts
    [x,fval,exitflag,output] = linprog(f,A,b,Aeq_iter,beq_iter,lb,ub,[],lp_options);
    
    if exitflag == 1
        disp(strcat('Success! lp_iter = ', num2str(lp_iter)));
        Aeq = Aeq_iter;
        beq = beq_iter;
        
        % pick new variable to try
        stop_lp_attempts = 1;
        indices_to_check = find( abs(x(intcon)-1) < 1e-5 );
        for check_index = 1:length(indices_to_check)
            next_var_index = indices_to_check(check_index);
            if var_unint_attempts_id(next_var_index) ~= 1
                var_unint_attempts_id(next_var_index) = 1;
                stop_lp_attempts = 0;
                break;
            end
        end
        if stop_lp_attempts == 1
            disp('Stopping LP attempts. No variable to un-integerize');
            break;
        end
        
        new_constraint_row = zeros(1,num_variables);
        new_constraint_row(next_var_index) = 1;
    
        Aeq_iter = [Aeq_iter ; new_constraint_row];
        beq_iter = [beq_iter ; 1];
    else
        Aeq_iter = Aeq;
        beq_iter = beq;
    end
end

return;

%% solve the MILP
milp_options = optimoptions('intlinprog');
milp_options.CutGenMaxIter = 25;
milp_options.CutGeneration = 'intermediate';
milp_options.IPPreprocess = 'advanced';
milp_options.TolGapRel = 1e-15;
milp_options.HeuristicsMaxNodes = 100;
milp_options.Heuristics = 'rins';
milp_options.MaxTime = 10*60; % 10 minutes

tic
[x,fval,exitflag,output] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,milp_options);
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