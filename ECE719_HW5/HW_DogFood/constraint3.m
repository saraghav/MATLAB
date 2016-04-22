function satisfied = constraint3(varargin)

decision = varargin;

satisfied = (25*decision{1} + 6*decision{2} >= 150);