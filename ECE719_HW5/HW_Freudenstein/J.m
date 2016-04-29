function val = J(varargin)

X = varargin;

f_1 = @(x) ( x{2} - x{1}.^3 + 5*x{1}.^2 -  2*x{1} - 13 );
f_2 = @(x) ( x{2} + x{1}.^3 +   x{1}.^2 - 14*x{1} - 29 );

val = f_1(X).^2 + f_2(X).^2;