% iterative optimization

syms u1 u2 u3;

f = 8*u1*u2*u3 - 4*u1*u2 - 4*u1*u3 - 4*u2*u3 + 2*u1 + 2*u2 + 2*u3 - 1;
subs(f, [u2, u3], [1, 1]);
subs(f, [u1, u3], [-1, 1]); % u1 = -1
subs(f, [u1, u2], [-1, 1]) % u2 = 1
