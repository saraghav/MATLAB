% show sig names

data = actrl_v10_001;
% data = actrl_v10_016;

display_text = cell(1,length( data.Y ));

for i=1:1:length( data.Y )
    name = data.Y(1,i).Name;
    path = data.Y(1,i).Path;
    display_text{1,i} = sprintf('%4d %30s %30s', i, name, path);
    disp(display_text{1,i});
end