function result = print_pole_zero_difference(transfer_func)

tf_zeros = transfer_func.z{1,1};
tf_poles = transfer_func.p{1,1};

tf_nzeros = length(tf_zeros);
tf_npoles = length(tf_poles);

result = cell(tf_npoles*tf_nzeros,5);

index = 1;
for i=1:1:tf_nzeros
    for j=1:1:tf_npoles
        result{index,1} = i;
        result{index,2} = sprintf('%e', tf_zeros(i));
        result{index,3} = j;
        result{index,4} = sprintf('%e', tf_poles(j));
        result{index,5} = sprintf('%e', abs(tf_zeros(i) - tf_poles(j)));
        index = index+1;
    end
end
