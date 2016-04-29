% data set generator
clear; clc;

n1 = 200;
n2 = 300;
r = 10;
m = 145;

N = 1;

U_list = cell(N,1);
V_list = cell(N,1);
S_list = cell(N,1);
M_full_list = cell(N,1);
omega_list = cell(N,1);
M_list = cell(N,1);

mu_0_list = zeros(N,1);
mu_1_list = zeros(N,1);
min_m_list = zeros(N,1);

for n_testcase=1:N
    U = orth(rand(n1,r));
    V = orth(rand(n2,r));
    
    S = zeros(r,r);
    for i=1:r
        S(i,i) = r-i+1;
    end
    
    M_full = U*S*V';
    
    M = zeros(n1,n2);
    
    omega = [randi(n1,m,1) randi(n2,m,1)];
    for obs_i = 1:size(omega,1)
        coord = omega(obs_i,:);
        M(coord(1), coord(2)) = M_full(coord(1), coord(2));
    end
    
    U_list{n_testcase} = U;
    S_list{n_testcase} = S;
    V_list{n_testcase} = V;
    M_full_list{n_testcase} = M_full;
    omega_list{n_testcase} = omega;
    M_list{n_testcase} = M;
    
    mu_0_U = n1/r * max( sqrt( sum((U'*eye(n1)).^2, 1) ) );
    mu_0_V = n2/r * max( sqrt( sum((V'*eye(n2)).^2, 1) ) );
    mu_0 = max(mu_0_U, mu_0_V);
    mu_1 = max(max(U*V'));
    
    mu_0_list(n_testcase) = mu_0;
    mu_1_list(n_testcase) = mu_1;
    
    beta = 1;
    
    min_m = 32*max(mu_1^2,mu_0)*r*(n1+n2)*beta*log(2*n2)^2;
    min_m = round(min_m);
    min_m_list(n_testcase) = min_m;
end

[p, q] = meshgrid(1:n1,1:n2);
all_coords = [p(:) q(:)];
clear p q;

% save testcase_1;
save testcase_2;