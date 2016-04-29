function GradJ_X = GradJ(varargin)

X = varargin;

f_1 = @(x) ( x{2} - x{1}.^3 + 5*x{1}.^2 -  2*x{1} - 13 );
f_2 = @(x) ( x{2} + x{1}.^3 +   x{1}.^2 - 14*x{1} - 29 );
Gradf_1 = @(x) [ -3*x{1}.^2 + 10*x{1} -  2 ; 1*ones(1,length(x{1})) ];
Gradf_2 = @(x) [  3*x{1}.^2 +  2*x{1} - 14 ; 1*ones(1,length(x{1})) ];

% bsxfun is used for column-wise multiplication as needed in this case
% if the each x_i of the input X is vectorized as a row vector
GradJ_X = 2 * bsxfun(@times, f_1(X), Gradf_1(X)) + 2 * bsxfun(@times, f_2(X), Gradf_2(X));