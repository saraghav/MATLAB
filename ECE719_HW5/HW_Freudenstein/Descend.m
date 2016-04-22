function [iterate, GradJ_x_k] = Descend(x_k, h, varargin)

arg = num2cell(x_k);
GradJ_x_k = GradJ( arg{:} );

if isempty(varargin)
    % steepest descent
    direction_unnormalized = - GradJ_x_k;
else
    direction_unnormalized = varargin{1};
end

% to avoid division by zero when at optimum
direction_norm_thresh = 1e-9;
if norm(direction_unnormalized) <= direction_norm_thresh
    iterate = x_k;
else
    direction = direction_unnormalized' / norm(direction_unnormalized);
    del_x = h * direction;
    iterate = x_k + del_x;
end