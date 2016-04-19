% data_set_generator
clear; close all; clc;

%% people generation
n_cities = 50;
n_people = 1e6;
people_per_city = round(n_people/n_cities);
if n_cities * people_per_city ~= n_people
    disp('ERROR: inconsistent parameters');
    return;
end

a = round(50*rand(n_cities,1)); % a >= 1
b = round(50*rand(n_cities,1)); % b >= 1

X = zeros(n_people, 2);
for city=1:n_cities
    offset = round(n_people/n_cities)*(city-1);
    if mod(city,2) == 0
        X(offset+(1:people_per_city), 1) = 50*betarnd(a(city), b(city), [people_per_city, 1]);
        X(offset+(1:people_per_city), 2) = 100*normrnd(b(city), a(city), [people_per_city, 1]);
    else
        X(offset+(1:people_per_city), 1) = 50*normrnd(b(city), a(city), [people_per_city, 1]);
        X(offset+(1:people_per_city), 2) = 100*betarnd(a(city), b(city), [people_per_city, 1]);
    end
end

backup = 100*rand(n_people,2);

X( X(:,1)>100 ,1) = backup( X(:,1)>100 ,1);
X( X(:,1)<0 ,1) = backup( X(:,1)<0 ,1);
X( X(:,2)>100 ,2) = backup( X(:,2)>100 ,2);
X( X(:,2)<0 ,2) = backup( X(:,2)<0 ,2);

%% shop generation
n_competitors = 10;
Y = 100*rand(n_competitors,2);

%% my limits
n = 10;

%% plot data
figure(1); legend_list = {};
hold on; grid on; grid minor;
plot(X(:,1), X(:,2), '.', 'MarkerSize', 5);
plot(Y(:,1), Y(:,2), 'x', 'MarkerSize', 10);
xlim([-10 110]);
ylim([-10 110]);

return;
%% save data
target_dir = '6';
if ~exist(target_dir, 'dir')
    mkdir(target_dir);
else
    disp('Data set already exists. Please choose another target dir');
    return;
end

save(strcat(target_dir, '/', 'X.mat'), 'X');
save(strcat(target_dir, '/', 'Y.mat'), 'Y');
save(strcat(target_dir, '/', 'n.mat'), 'n');