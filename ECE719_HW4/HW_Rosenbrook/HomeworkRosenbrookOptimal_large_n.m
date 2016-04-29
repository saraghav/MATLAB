%% homework rosenbrook optimal
clear;
close all;
clc;
p = 1;

result_iterates = {};
h_iterates = {};
final_J_iterates = {};
runtime_iterates = {};

n = 500;

u_0_list = [
    ones(1,n);
    -ones(1,n);
];
u_0_list = u_0_list * 2;

H_list = [1];

for i=1:length(u_0_list(:,1))
    i
    u_0 = u_0_list(i,:);
    for j=1:length(H_list)
        j
        H = H_list(j);
        
        tic;
        [iterates_list, h_list] = SteepestDescentOptimal(u_0, H);
        runtime = toc;
        
        result_iterates{i,j} = iterates_list;
        h_iterates{i,j} = h_list;
        arg = num2cell( iterates_list(end,:) );
        final_J_iterates{i,j} = J( arg{:} );
        runtime_iterates{i,j} = runtime;
    end
end
