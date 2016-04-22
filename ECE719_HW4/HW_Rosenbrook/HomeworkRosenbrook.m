%% homework rosenbrook
clear;
close all;
clc;
p = 1;

result_iterates = {};
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

h_list = [1e-3, 1e-2, 1e-1, 1];

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

%% plots

figure(p); hold on; grid on; grid minor; p = p+1;
fighandle = ezcontourf(@J, [-2.5, 2.5], 100);
fighandle.LevelList = logspace(-3,4,50);

h_index = 3;

for i=1:length(u_0_list(:,1))
%     i=1;
    plot(result_iterates{i,h_index}(:,1), result_iterates{i,h_index}(:,2), '--', 'LineWidth', 2);
%     break;
end
