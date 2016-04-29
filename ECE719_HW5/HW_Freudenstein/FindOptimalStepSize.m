function [h, GradJ_x_k] = FindOptimalStepSize(x_k, H, varargin)

% line search parameters
fraction_termination_improvement = 0.5;
shrink_step_size = 0.5;
h = H; % start with max

% evaluate current location
arg = num2cell(x_k);
J_value = J( arg{:} );
GradJ_x_k = GradJ( arg{:} );

% if direction is provided, use direction
%   else assume steepest descent
if isempty(varargin)
    direction_unnormalized = - GradJ_x_k;
else
    direction_unnormalized = varargin{1};
end

% to avoid division by zero when at optimum
direction_norm_thresh = 1e-9;
if norm(direction_unnormalized) <= direction_norm_thresh
    h = 0;
else
    % normalize the direction
    direction = direction_unnormalized' / norm(direction_unnormalized);
    
    % local slope along direction
    m = direction * GradJ_x_k;
    
    % iterate until reasonable improvement
    %   but not forever
    iteration_limit = 1e8;
    iteration = 1;
    while(1)
        % 'h' sized step along direction
        del_x = h * direction;
        x_k_step = x_k + del_x;
        
        % evaluate function at the step
        arg = num2cell(x_k_step);
        J_value_at_step = J( arg{:} );
        
        % evaluate minimum improvement for termination
        min_decrease = h * fraction_termination_improvement * m;
        if J_value_at_step <= J_value + min_decrease
            break;
        end
        
        % can't move so fast; look nearer for improvements
        h = h*shrink_step_size;
        
        % stop if iterations aren't behaving
        iteration = iteration + 1;
        if iteration > iteration_limit
            disp('WARNING: Iteration limit in line search');
            break;
        end
    end
end