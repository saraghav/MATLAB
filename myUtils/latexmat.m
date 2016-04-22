function matrix_in_latex = latexmat(A)

% matrix_in_latex = latex(sym(mat2str(A)));
Acell = {};
Arows = {};
for i=1:size(A,1)
    for j=1:size(A,2)
        Acell{i,j} = num2str(A(i,j),'%.1f');
    end
    
    Arows{i,1} = strjoin(Acell(i,:), ' & ');
    Arows{i,1} = [Arows{i,1} ' \\'];
end

Adisp = strjoin(Arows, '\n');
disp('\begin{bmatrix}');
disp(Adisp);
disp('\end{bmatrix}');