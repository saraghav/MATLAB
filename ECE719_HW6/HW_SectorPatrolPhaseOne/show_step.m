function show_step(i)

global display_matrix_history solution_indices_history new_variable_index_history aug_mat_before_history aug_mat_after_history x_history;

disp('display_matrix_history');
latexmat(display_matrix_history{i})

disp('solution_indices_history');
latexmat(solution_indices_history{i})

disp('new_variable_index_history');
latexmat(new_variable_index_history{i})

disp('aug_mat_before_history');
latexmat(aug_mat_before_history{i})

disp('aug_mat_after_history');
latexmat(aug_mat_after_history{i})

disp('x_history');
latexmat(x_history{i})