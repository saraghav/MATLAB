function [iterate, GradJ] = Descend(u_k, h)

% J = @(u1,u2) (11-u1-u2).^2 + (1+u1+10*u2-u1.*u2).^2;

GradJ_u1 = @(u1,u2) -20 + 4*u1 + 20*u2 - 4*u1.*u2 - 20*u2.^2 + 2*u1.*u2.^2;
GradJ_u2 = @(u1,u2) -2 + 20*u1 + 202*u2 - 20*u1.*u2 - 2*u1.^2 - 20*u1.*u2 + 2*u1.^2*u2;

GradJ = [
    GradJ_u1(u_k(1),u_k(2)) ;
    GradJ_u2(u_k(1),u_k(2))
];

% to avoid division by zero when at optimum
thresh = 1e-9;
if norm(GradJ) <= thresh
    iterate = u_k;
else
    del_u = - h * GradJ' / norm(GradJ);
    iterate = u_k + del_u;
end