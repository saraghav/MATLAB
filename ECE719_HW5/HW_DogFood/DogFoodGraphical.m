% Graphical Solution
clear; close all; clc;
load constraints_inline;

obj = @(x) -1.2*x;

figure(1); hold on; grid on; grid minor; legend_list = {};
H1 = ezplot(c1, [0 20]); legend_list = [legend_list 'Constraint 1'];
H1.LineWidth = 3;
H2 = ezplot(c2, [0 20]); legend_list = [legend_list 'Constraint 2'];
H2.LineWidth = 3;
H3 = ezplot(c3, [0 20]); legend_list = [legend_list 'Constraint 3'];
H3.LineWidth = 3;

for c = 0.0129:5e-3:0.03
    obj_now = @(x) c*1e3 + obj(x);
    H = ezplot(obj_now, [0 20]);
    legend_string = ['cost = ' num2str(c)];
    if c == 0.0129
        legend_string = [legend_string ' (optimum)'];
    end
    legend_list = [legend_list legend_string];
    H.LineWidth = 2;
    H.LineStyle = '--';
end

xlim([0 20]);
ylim([0 20]);
legend(legend_list{:});
xlabel('Gaines Ration Dog Food (grams)');
ylabel('Kennel Ration Dog Food (grams)');

points = [];
for i=0:0.5:20
    for j=0:0.5:20
        if constraint1(i,j) && constraint2(i,j) && constraint3(i,j)
            points = [points ; i j];
        end
    end
end
scatter(points(:,1), points(:,2), 5, 'red', 'filled');