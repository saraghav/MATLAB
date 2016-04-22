%% homework freudenstein
clear;
close all;
clc;
p = 1;

result_iterates = {};
h_iterates = {};
J_list_iterates = {};
optimum_iterates = {};
final_J_iterates = {};
runtime_iterates = {};

x_0_list = [
    8, 15;
    -10, -10;
    -10, -50;
    -10, 10;
    -10, 50;
    -1, 20;
    0, -50;
    1, -50;
    1, 20;
    2, 20;
    10, -10;
    10, -50;
    10, 10;
    10, 50;
];

H_list = [10];

for i=1:length(x_0_list(:,1))
    i
    x_0 = x_0_list(i,:);
    for j=1:length(H_list)
        j
        H = H_list(j);
        
        tic;
        [iterates_list, h_list, J_list] = ConjugateGradientMethod(x_0, H);
        runtime = toc;
        
        result_iterates{i,j} = iterates_list;
        h_iterates{i,j} = h_list;
        J_list_iterates{i,j} = J_list;
        optimum_iterates{i,j} = iterates_list(end,:);
        final_J_iterates{i,j} = J_list(end);
        runtime_iterates{i,j} = runtime;
    end
end

niterations_iterates = zeros(length(x_0_list(:,1)),1);
for i=1:length(x_0_list(:,1))
    niterations_iterates(i) = length(result_iterates{i});
end

summary_table = [ x_0_list, cell2mat(optimum_iterates), cell2mat(final_J_iterates), niterations_iterates, cell2mat(runtime_iterates) ];

%% plots

% contour
figure(p); hold on; grid on; grid minor; p = p+1;
fighandle = ezcontourf(@J, [-15 15 -60 60], 200);
fighandle.LevelList = logspace(-9,9,100);

h_index = 1;

show = 1:length(x_0_list(:,1)); 
for i=show
    plot(result_iterates{i,h_index}(:,1), result_iterates{i,h_index}(:,2), '--', 'LineWidth', 2);
end