% data generation
clear; clc; close all;
load SGD_data_n_1000;

noise_observations = 0.5*randn(n,1);
x = (x_max-x_min)*rand(n,p) + x_min;
y_continuous = x * w;
y = 2*(y_continuous>=0) - 1;

filename = 'SGD_data_n_1000_testing';
save(filename);
