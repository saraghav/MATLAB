%% homework rosenbrook optimal
clear;
close all;
clc;
p = 1;

result_iterates = {};
h_iterates = {};
final_J_iterates = {};
runtime_iterates = {};

u_0_list = [
    1, 1;
    1, -1;
    -1, 1;
    -1, -1;
];
u_0_list = u_0_list * 2;
% u_0_list = u_0_list(1,:);

H_list = [1e-1, 1e-2, 1, 10];

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

%% plots

figure(p); hold on; grid on; grid minor; p = p+1;
fighandle = ezcontourf(@J, [-2.5, 2.5], 100);
fighandle.LevelList = logspace(-3,4,50);

h_index = 4;

for i=1:length(u_0_list(:,1))
    plot(result_iterates{i,h_index}(:,1), result_iterates{i,h_index}(:,2), '--', 'LineWidth', 2);
end
