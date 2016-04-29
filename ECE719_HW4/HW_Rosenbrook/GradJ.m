function GradJ_u_k = GradJ(u_k)

GradJ_u_k = zeros(length(u_k),1);

GradJ_u_k(1) = -400*u_k(1)*(u_k(2) - u_k(1)^2) - 2*(1-u_k(1));

for i=2:length(u_k)-1
    GradJ_u_k(i) = 200*(u_k(i)-u_k(i-1)^2) ...
                    - 400*u_k(i)*(u_k(i+1) - u_k(i)^2) ...
                    - 2*(1-u_k(i));
end

GradJ_u_k(end) = 200*(u_k(end)-u_k(end-1)^2);