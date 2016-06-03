% power of a matrix

A = [ 1 1 ; 1 2 ];

[V, D] = eig(A);

a = V(1,1);
b = V(1,2);
c = V(2,1);
d = V(2,2);
l1 = D(1,1);
l2 = D(2,2);

% num = @(k) (a^2+2*a*b)*l1^(k-1) + (b*c+2*b*d)*l2^(k-1);
% den = @(k) (a*c+2*b*c)*l1^(k-1) + (c*d+2*d^2)*l2^(k-1);

num = @(k) 1.1708*2.618^(k-1) - 0.1708*0.382^(k-1);
den = @(k) 1.8944*2.618^(k-1) + 0.1056*0.382^(k-1);