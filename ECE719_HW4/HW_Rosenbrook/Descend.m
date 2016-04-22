function [iterate, GradJ_u_k] = Descend(u_k, h)

GradJ_u_k = GradJ(u_k);

% to avoid division by zero when at optimum
thresh = 1e-9;
if norm(GradJ_u_k) <= thresh
    iterate = u_k;
else
    del_u = - h * GradJ_u_k' / norm(GradJ_u_k);
    iterate = u_k + del_u;
end