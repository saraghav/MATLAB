function iterates = SteepestDescent(u_k, h)

J = @(u1,u2) (11-u1-u2).^2 + (1+u1+10*u2-u1.*u2).^2;

iterates = u_k;
thresh = 1e-9;

iteration = 1;
while(1)
    % iteration
    
    [next_iterate, GradJ] = Descend(iterates(end,:), h);
    
    % delta = norm(next_iterate - iterates(end,:));
    % delta = norm(GradJ);
    J_last = J(iterates(end,1),iterates(end,2));
    J_now = J(next_iterate(1),next_iterate(2));
    delta = abs( J_last - J_now );
    
    iterates = [iterates ; next_iterate];
    
    if delta <= thresh
        disp('Terminating because improvement is below threshold');
        break;
    end
    if iteration >= 10000
        disp('Terminating because iteration limit is reached');
        break;
    end
    iteration = iteration + 1;
end