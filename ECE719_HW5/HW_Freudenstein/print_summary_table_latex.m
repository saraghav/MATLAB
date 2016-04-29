% latex output
s = size(summary_table);

for i = 1:1:s(1)
    for j = 1:1:s(2)
        str_value = num2str( round(summary_table(i,j),2) );
        fprintf('%s &', str_value);
    end
    fprintf('\n');
end