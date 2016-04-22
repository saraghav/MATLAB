function [iterates, h_used, J_list] = ConjugateGradientMethod(x_0, H)

iterates = x_0;
h_used = 0;
conjugate_direction_list = [];

arg = num2cell(x_0);
J_list = J( arg{:} );

% termination conditions
improvement_thresh = 1e-9;
max_no_improvement_iterations = 10;
no_improvement_iterations = 0;
iteration_limit = 10000;

iteration = 1;
while(1)
    if iteration == 1
        % use steepest descent for the first iteration
        [h, GradJ_x_0] = FindOptimalStepSize(iterates(end,:), 10);
        [next_iterate, ~] = Descend(iterates(end,:), h);
        conjugate_direction_list = [conjugate_direction_list ; GradJ_x_0'];
    else
        % use conjugate directions for the rest of the iterations
        conjugate_direction = PolakRibiere(iterates(end-1:end,:), conjugate_direction_list(end,:));
        [h, ~] = FindOptimalStepSize(iterates(end,:), H, conjugate_direction);
        [next_iterate, ~] = Descend(iterates(end,:), h, conjugate_direction);
        conjugate_direction_list = [conjugate_direction_list ; conjugate_direction'];
    end
    
    % check for improvement thresh
    %   and termination
    arg = num2cell(iterates(end,:));
    J_last = J( arg{:} );
    arg = num2cell(next_iterate(1,:));
    J_now = J( arg{:} );
    delta = abs( J_last - J_now );
    
    iterates = [iterates ; next_iterate];
    h_used = [h_used ; h];
    J_list = [J_list ; J_now];
    
    if delta <= improvement_thresh
        no_improvement_iterations = no_improvement_iterations + 1;
        if no_improvement_iterations >= max_no_improvement_iterations
            disp('Terminating because improvement is below threshold');
            break;
        end
    else
        no_improvement_iterations = 0;
    end
    if iteration >= iteration_limit
        disp('Terminating because iteration limit is reached');
        break;
    end
    iteration = iteration + 1;
end