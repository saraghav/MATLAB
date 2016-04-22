function satisfied = constraint1(varargin)

decision = varargin;

satisfied = (8*decision{1} + 3*decision{2} >= 48);