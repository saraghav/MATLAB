%% homework rosenbrook
clear;
close all;
clc;
p = 1;

result_iterates = {};
final_J_iterates = {};
runtime_iterates = {};

n = 500;

u_0_list = [
    ones(1,n);
    -ones(1,n);
];
u_0_list = u_0_list * 2;

h_list = [1e-3, 1e-2, 1e-1];

for i=1:length(u_0_list(:,1))
    i
    u_0 = u_0_list(i,:);
    for j=1:length(h_list)
        j
        h = h_list(j);
        
        tic;
        iterates_list = SteepestDescent(u_0, h);
        runtime = toc;
        
        result_iterates{i,j} = iterates_list;
        arg = num2cell( iterates_list(end,:) );
        final_J_iterates{i,j} = J( arg{:} );
        runtime_iterates{i,j} = runtime;
    end
end