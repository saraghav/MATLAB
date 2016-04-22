function show_nutrients(A,x)

nutrients = {
    'calories' ;
    'protein' ;
    'fat' ;
    'iron' ;
    'calcium' ;
    'phosphorus' ;
    'potassium' ;
    'sodium' ;
    'vitamin_A' ;
    'vitamin_B1' ;
    'vitamin_B2' ;
    'vitamin_C' ;
};

constraint_values = A*x;
nutrients_received = -constraint_values(1:length(nutrients));
nutrients_display = mat2cell(num2str(nutrients_received,'%.3f'), ones(length(nutrients),1), [8 zeros(1,7)]);
nutrients_display = nutrients_display(:,1);
nutrients_display = [nutrients nutrients_display];
nutrients_display