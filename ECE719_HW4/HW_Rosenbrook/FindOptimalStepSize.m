function h = FindOptimalStepSize(u_k, H)

fraction = 0.5;
shrink = 0.5;
h = H; % start with max

arg = num2cell(u_k);
J_value = J( arg{:} );

GradJ_u_k = GradJ(u_k);

% to avoid division by zero when at optimum
thresh = 1e-9;
if norm(GradJ_u_k) <= thresh
    h = 0;
else
    p = - GradJ_u_k' / norm(GradJ_u_k);
    m = p * GradJ_u_k;
    while(1)
        del_u = h * p;
        u_k_step = u_k + del_u;
        arg = num2cell(u_k_step);
        J_value_at_step = J( arg{:} );
        
        min_decrease = h * fraction * m;
        
        if J_value_at_step <= J_value + min_decrease
            break;
        end
        
        h = h*shrink;
    end
end