% Homework Minimax

A = [
    2 2 0;
    -2 -2 0;
    1.5 -1 0;
    1/30 1/15 -1;
    3/10 1/5 -1;
    2 1/2 -1;
    1 1 -1;
    -1 0 0;
    0 -1 0;
];

b = [
    10 ; 0 ; -4 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ;
];

c = [
    0 ; 0 ; 1 ;
];

Aeq = [];
beq = [];

[x, fval, exitflag, output, lambda] = linprog(c, A, b, Aeq, beq);