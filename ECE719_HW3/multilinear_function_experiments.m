% multilinear functions experiments
clear; close all;
p = 1;

% % expt
% syms x y;
% mlf = x + y + x*y;
% figure(p); p=p+1; hold on;
% ezsurf(mlf, [-10 10], [-10 10]);
% ezsurf(mlf + 5, [-10 10], [-10 10]);

syms u1 u2;

% constraints
% |u1| <= 1 , |u2| <= 1
% J(u) = u1 + u2
% J_u = -(u1*u2 + u1 + u2);
% figure(p); p=p+1; hold on;
% ezsurf(J_u, [-1 1], [-1 1]);
% return;

% constraints
% |u1| <= 1 , |u2| <= 1
% J(u) = u1
% J_u = -u1;
% figure(p); p=p+1; hold on;
% ezsurf(J_u, [-1 1], [-1 1]);

% constraints
% |u1| <= 1 , |u2| <= 1
% J_u = 1 / (u1 * u2 * (u1^2-1) * (u2^2-1));
% figure(p); p=p+1; hold on;
% ezsurf(J_u, [-1 1], [-1 1]);

% multilinear function quotient
J_u = (u1 + u2 + 10) / (u1 - u2 + 5);
ezsurf(J_u, [-1 1], [-1 1]);