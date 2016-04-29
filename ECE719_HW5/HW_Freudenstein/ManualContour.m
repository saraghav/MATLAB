% manual contour

% x1 = -10:1e-1:10;
% x2 = -50:1e-1:50;
% x1 = 4 + [-logspace(-3,log10(14),500) logspace(-3,log10(6),500)];
% x2 = 5 + [-logspace(-3,log10(55),500) logspace(-3,log10(45),500)];
% 
% [X1, X2] = meshgrid(x1,x2);
% 
% Jmat = X1;
% Jsize = size(Jmat);
% for i=1:Jsize(1)
%     for j=1:Jsize(2)
%         X = [X1(i,j) X2(i,j)];
%         arg = num2cell(X);
%         Jmat(i,j) = J(arg{:});
%     end
% end
% 
% contourf(X1,X2,Jmat);
% xlim([-10 10]);
% ylim([-50 50]);

% show = [1, 8, 9, 11, 12, 13];
% show = [9, 10];
% show = [2, 3, 4, 5, 6, 7, 10, 14];
% show = [5, 6, 7];
% show = [10, 14];
