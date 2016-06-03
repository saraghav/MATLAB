function matrix = findp(power)

a = evalin('base','a');
b = evalin('base','b');
c = evalin('base','c');
d = evalin('base','d');
l1 = evalin('base','l1');
l2 = evalin('base','l2');

matrix = [
    (a^2*l1^power)+(b*c*l2^power) (a*b*l1^power)+(b*d*l2^power) ;
    (a*c*l1^power)+(c*d*l2^power) (b*c*l1^power)+(d^2*l2^power) ;
];