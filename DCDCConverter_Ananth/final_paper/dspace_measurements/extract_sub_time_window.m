% extract sub-time window signal
% positions stored in cursor_info1 and cursor_info2

data_source2 = data_source;

start_index = find( data_source2.X.Data == cursor_info1.Position(1) );
end_index = find( data_source2.X.Data == cursor_info2.Position(1) );

data_source2.X.Data = data_source2.X.Data(start_index:end_index);

for i = 1:length(data_source2.Y)
    data_source2.Y(1,i).Data = data_source2.Y(1,i).Data(start_index:end_index);
end