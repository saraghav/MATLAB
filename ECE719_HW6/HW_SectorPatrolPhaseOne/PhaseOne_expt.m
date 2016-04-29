% Sector Patrol Phase One
clear; clc;

% introduce three new variables
A = [
       2 2 1  0  0 1 0 0 ;
       2 2 0 -1  0 0 1 0 ;
    -1.5 1 0  0 -1 0 0 1 ;
];

b = [
    10 ;
    4  ;
    0  ;
];

c = [
    0; 0; 0; 0; 0; 1; 1; 1;
];

solution_indices = [6 7 8];

nconstraints = size(A,1);
nvars = size(A,2);
% all_constraint_indices = 1:nconstraints;
all_constraint_indices = [2 3 1];
all_var_indices = 1:nvars;

A_orig = A;
b_orig = b;

global display_matrix_history solution_indices_history new_variable_index_history aug_mat_before_history aug_mat_after_history x_history;

display_matrix_history = {};
solution_indices_history = {};
new_variable_index_history = {};
aug_mat_before_history = {};
aug_mat_after_history = {};
x_history = {};

for iter=all_constraint_indices
    indices_of_interest = ismember(all_var_indices, solution_indices);
    
    rel_cost_interim = bsxfun(@times, c(indices_of_interest), A);
    rel_cost = zeros(1,nvars);
    for varindex=all_var_indices
        rel_cost_interim_column = rel_cost_interim(:,varindex);    
        rel_cost(varindex) = c(varindex) - c(indices_of_interest)' * rel_cost_interim_column;
    end
    display_matrix = vertcat(A, rel_cost);
    display_matrix_history{iter} = display_matrix;
    display_matrix
    
    min_rel_cost = 0;
    new_variable_index = -1;
    for varindex=all_var_indices
        if rel_cost(varindex) < 0
            if rel_cost(varindex) < min_rel_cost
                if A(iter,varindex) ~= 0
                    min_rel_cost = rel_cost(varindex);
                    new_variable_index = varindex;
                end
            end
        end
    end
    
    solution_indices(iter) = new_variable_index;
    new_variable_index
    
    solution_indices_history{iter} = solution_indices;
    new_variable_index_history{iter} = new_variable_index;
    
    aug_mat = horzcat(A,b);
    
    aug_mat_before = aug_mat
    aug_mat_before_history{iter} = aug_mat_before;
    
    aug_mat(iter, :) = aug_mat(iter, :) / aug_mat(iter, new_variable_index);
    other_constraints = all_constraint_indices(~ismember(all_constraint_indices,iter));
    for iter2=other_constraints
        aug_mat(iter2,:) = aug_mat(iter2,:) - aug_mat(iter,:)*aug_mat(iter2, new_variable_index);
        if aug_mat(iter2,end) < 0
            aug_mat(iter2,:) = -aug_mat(iter2,:);
        end
    end
    
    aug_mat_after = aug_mat
    aug_mat_after_history{iter} = aug_mat_after;
    
    A = aug_mat_after(:,all_var_indices);
    b = aug_mat_after(:,end);
    
    x = zeros(nvars,1);
    x(solution_indices) = b;
    x_history{iter} = x;
    
    disp('------------------------------------------------------------');
end