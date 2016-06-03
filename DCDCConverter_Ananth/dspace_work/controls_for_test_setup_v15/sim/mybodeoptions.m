% mybodeoptions

P_DS = bodeoptions;
% P.Title.String = 'Dynamic Stiffness Freq Response';
P_DS.Title.String = ' ';
P_DS.PhaseVisible = 'off';
P_DS.Grid = 'on';
P_DS.MagUnits = 'abs';
P_DS.MagScale = 'log';
P_DS.FreqUnits = 'Hz';
P_DS.FreqScale = 'log';
P_DS.PhaseUnits = 'deg';
P_DS.xlim = [1e-3,50e3];
P_DS.PhaseWrapping = 'on';

P_CT = bodeoptions;
% P.Title.String = 'Dynamic Stiffness Freq Response';
P_CT.Title.String = ' ';
P_CT.PhaseVisible = 'on';
P_CT.Grid = 'on';
P_CT.MagUnits = 'abs';
P_CT.MagScale = 'linear';
P_CT.FreqUnits = 'Hz';
P_CT.FreqScale = 'log';
P_CT.PhaseUnits = 'deg';
P_CT.xlim = [1e-3,50e3];
P_CT.YLim = {[0,2];[-90,90]};
P_CT.PhaseWrapping = 'on';