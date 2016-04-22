%% homework amplifier
clear;
close all;
clc;
p = 1;

J = @(u1, u2) (11 - u1 - u2).^2 + (1 + u1 + 10*u2 - u1.*u2).^2;
GradJ_u1 = @(u1,u2) -20 + 4*u1 + 20*u2 - 4*u1.*u2 - 20*u2.^2 + 2*u1.*u2.^2;
GradJ_u2 = @(u1,u2) -2 + 20*u1 + 202*u2 - 20*u1.*u2 - 2*u1.^2 - 20*u1.*u2 + 2*u1.^2*u2;

result_iterates = {};
final_J_iterates = {};
runtime_iterates = {};

u_0_list = [
    8, 12;
    5, 10;
    12, 14;
    12, 10;
];

% u_0_list = [
%     2, 0;
%     4, 0;
%     5, 0;
%     6, 0;
%     8, 0;
% ];

h_list = [0.01, 0.1, 1];

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
        final_J_iterates{i,j} = J(iterates_list(end,1),iterates_list(end,2));
        runtime_iterates{i,j} = runtime;
    end
end

%% plots

figure(p); hold on; grid on; grid minor; p = p+1;
fighandle = ezcontourf(J, [0, 10, -5, 5], 100);
% fighandle.LevelStep = 100;
fighandle.LevelList = logspace(-8,5,60);

h_index = 1;

for i=1:length(u_0_list(:,1))
    plot(result_iterates{i,h_index}(:,1), result_iterates{i,h_index}(:,2), '--', 'LineWidth', 2);
end