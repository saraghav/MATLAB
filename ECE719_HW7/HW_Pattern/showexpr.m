function expr = showexpr(k)

a = evalin('base','a');
b = evalin('base','b');
c = evalin('base','c');
d = evalin('base','d');
l1 = evalin('base','l1');
l2 = evalin('base','l2');

% a = vpa(a,4);
% b = vpa(b,4);
% c = vpa(c,4);
% d = vpa(d,4);
% l1 = vpa(l1,4);
% l2 = vpa(l2,4);

num = (a^2+2*a*b)*l1^(k-1) + (b*c+2*b*d)*l2^(k-1);
den = (a*c+2*b*c)*l1^(k-1) + (c*d+2*d^2)*l2^(k-1);

% expr = [ num ; den ];

expr = num/den;