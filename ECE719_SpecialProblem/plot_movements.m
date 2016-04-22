% plot movements
n = size(U_history,1);
for store = 1:n
    hold on;
    plot( U_history{store}(:,1), U_history{store}(:,2), '--', 'LineWidth', 2)
end