function iterates = SteepestDescent(u_k, h)

iterates = u_k;
thresh = 1e-9;

iteration = 1;
while(1)
    % iteration
    
    [next_iterate, GradJ] = Descend(iterates(end,:), h);
    
    % delta = norm(next_iterate - iterates(end,:));
    % delta = norm(GradJ);
    
    arg = num2cell(iterates(end,:));
    J_last = J( arg{:} );
    arg = num2cell(next_iterate(1,:));
    J_now = J( arg{:} );
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