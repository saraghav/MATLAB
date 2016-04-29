function satisfied = constraint2(varargin)

decision = varargin;

satisfied = (11*decision{1} + 15*decision{2} >= 165);