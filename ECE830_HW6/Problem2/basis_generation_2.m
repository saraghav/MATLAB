% basis generation for data
clear; close all; clc;

basis_id = 2;

p = 6;
r = 4;
V_star = mvnrnd(zeros(1,p), eye(p), r);

filename = strcat('basis_', num2str(basis_id));
save(filename);