%% Analysis
clear; clc;

n1 = 200;
n2 = 300;

[p, q] = meshgrid(1:n1,1:n2);
all_coords = [p(:) q(:)];
clear p q;

r_list = round(linspace(10,n1/2,5));
m_list = round(linspace(1,n1*n2,20));
mse_list = zeros(length(m_list), length(r_list));

mu_0_list = zeros(size(r_list));

for testcase_i=1
    for j=1:length(r_list)
        r = r_list(j);
        
        U = orth(rand(n1,r));
        V = orth(rand(n2,r));
        
        P_U = U * ( (U'*U) \ U' );
        P_V = V * ( (V'*V) \ V' );
        mu_0_U = n1/r * max( sqrt( sum((P_U*eye(n1)).^2, 1) ) );
        mu_0_V = n1/r * max( sqrt( sum((P_V*eye(n2)).^2, 1) ) );
        mu_0 = max(mu_0_U, mu_0_V);
        mu_0_list(j) = mu_0;
        
        continue;
        
        diag_elements = randi(50, r, 1);
        S = diag( sort(diag_elements, 'descend') );
    
        M_full = U*S*V';
    
        for i=1:length(m_list)
            m = m_list(i);
            
            omega_indices = datasample(1:n1*n2, m, 'Replace', false);
            omega = all_coords(omega_indices, :);
            
            M = zeros(n1,n2);
            
            for k=1:m
                M(omega(k,1), omega(k,2)) = M_full(omega(k,1), omega(k,2));
            end
            
            % actual algo
            
            X_0 = zeros(n1,n2);
            iter = 1;
            iter_max = 10000;
            X_k = X_0;
            thresh = 1e-6;

            lambda = 1e-1;
            while iter <= iter_max
                t = 0.5;

                X_km1 = X_k;
                X_k = prox_t(M, X_km1, t, lambda);

                if norm(X_k - X_km1, 'fro') <= thresh
                    disp('Improvement below threshold');
                    break;
                end
                iter = iter+1;
            end
            if iter > iter_max
                disp('Iteration limit');
            end
            
            X_star = X_k;
            
            mse_list(i,j) = mse(X_star, M_full);
        end
    end
end

%% plot

figure(1); clf;
hold on; grid on; grid minor;
plot(m_list, mse_list, 'LineWidth', 3);
legend_list = cell(length(r_list),1);
for i=1:length(r_list)
    legend_list{i} = ['r = ', num2str(r_list(i))];
end
legend(legend_list{:});
xlabel('m');
ylabel('Mean Squared Error : MSE(X^*, M^*)');

fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',14)