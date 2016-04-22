function conjugate_direction = PolakRibiere(iterates, last_direction)

% last two iterates
x_km1 = iterates(end-1,:);
x_k = iterates(end,:);

% convert to column vectors
x_km1 = x_km1';
x_k = x_k';
last_direction = last_direction';

% get the gradient values
arg = num2cell(x_km1);
GradJ_x_km1 = GradJ( arg{:} );
arg = num2cell(x_k);
GradJ_x_k = GradJ( arg{:} );

% calculate the parts of beta
beta_numerator = GradJ_x_k' * (GradJ_x_k - GradJ_x_km1);
beta_denominator = GradJ_x_km1' * GradJ_x_km1;

% protect against division-by-zero
beta_thresh = 1e-9;
if beta_denominator <= beta_thresh
    % disp('WARNING: beta denominator is almost zero');
    conjugate_direction = [0 ; 0];
else
    beta = beta_numerator / beta_denominator;
    conjugate_direction = -GradJ_x_k + beta * last_direction;
end