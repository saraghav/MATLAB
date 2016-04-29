function val = J(varargin)

u = varargin;
val = 0;

for i=1:length(varargin)-1
    val = val + 100*(u{i+1} - u{i}.^2).^2 + (1 - u{i}).^2;
end