%% Homework Diet
clear; clc;

% transcibed problem data

food = {
    'Whole milk' ;
    'Ice cream' ;
    'Eggs (scrambled or fried)' ;
    'Cheese (cheddar, American)' ;
    'Lean ground beef' ;
    'Broiled chicken' ;
    'Baked flounder' ;
    'French fried potatoes' ;
    'Frozen fruits' ;
    'Converted rice' ;
};

food_measures = [
    1 ; 1 ; 2 ; 1 ; 3 ; 3 ; 3.5 ; 10 ; 6 ; 1 ;
];

food_measures_units = {
    'qt' ;
    'cup' ;
    'nos' ;
    'in. cube' ;
    'oz' ;
    'oz' ;
    'oz' ;
    'pieces' ;
    'oz. can' ;
    'cup uncooked' ;
};

dairy_indices = [1 2 3 4];
meat_indices = [5 6 7];
vegetable_indices = 8;
fruit_indices = 9;
grain_indices = 10;

weights = [
    976 ; 188 ; 128 ; 17 ; 85 ; 85 ; 100 ; 60 ; 210 ; 187 ;
];

price = [
    0.4 ; 0.35 ; 0.15 ; 0.05 ; 0.25 ; 0.12 ; 0.25 ; 0.07 ; 0.30 ; 0.25 ;
];

calories = [
    660 ; 300 ; 220 ; 70 ; 185 ; 185 ; 200 ; 155 ; 330 ; 677 ;
];

protein = [
    32 ; 6 ; 13 ; 4 ; 24 ; 23 ; 30 ; 1 ; 2 ; 14 ;
];

fat = [
    40 ; 18 ; 16 ; 6 ; 10 ; 9 ; 8 ; 7 ; 0 ; 0 ;
];

iron = [
    0.4 ; 0.1 ; 2.2 ; 0.1 ; 3.0 ; 1.4 ; 1.4 ; 0.7 ; 0.8 ; 1.6 ;
];

calcium = [
    1140 ; 175 ; 60 ; 133 ; 10 ; 10 ; 22 ; 9 ; 69 ; 53 ;
];

phosphorus = [
    930 ; 150 ; 222 ; 128 ; 158 ; 250 ; 344 ; 6 ; 115 ; 244 ;
];

potassium = [
    210 ; 170 ; 140 ; 30 ; 340 ; 350 ; 585 ; 510 ; 1315 ; 300 ;
];

sodium = [
    75 ; 140 ; 338 ; 180 ; 110 ; 50 ; 235 ; 6 ; 4 ; 6 ;
];

vitamin_A = [
    1560 ; 740 ; 1200 ; 230 ; 20 ; 260 ; 0 ; 0 ; 1490 ; 0 ;
];

vitamin_B1 = [
    0.32 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0.60 ; 0.30 ;
];

vitamin_B2 = [
    1.7 ; 0.3 ; 0.4 ; 0.1 ; 0 ; 0.1 ; 0 ; 0 ; 0.1 ; 0 ;
];

vitamin_C = [
    6 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 8 ; 330 ; 0 ;
];

min_daily_allowance = [
    2400 ; 70 ; 0 ; 10 ; 800 ; 0 ; 0 ; 0 ; 5000 ; 1 ; 1.6 ; 70 ;
];

max_calories = 2800;
max_vitamin_A = 40000;

%% LP formulation

nutrients_in_food = [
    calories' ;
    protein' ;
    fat' ;
    iron' ;
    calcium' ;
    phosphorus' ;
    potassium' ;
    sodium' ;
    vitamin_A' ;
    vitamin_B1' ;
    vitamin_B2' ;
    vitamin_C' ;
];

chosen_quantities = eye(length(food)); % >= 0
zero_matrix = zeros(length(chosen_quantities),1);

% constraint potassium range
potassium_min = potassium' - 0.85*sodium'; % >= 0
potassium_max = potassium' - 1.15*sodium'; % <= 0

% calcium min
calcium_min = calcium' - 0.75*phosphorus'; % >= 0

A = [
    -nutrients_in_food ;
    calories' ;
    vitamin_A' ;
    -chosen_quantities ;
    -potassium_min ;
    potassium_max ;
    -calcium_min ;
];

b = [
    -min_daily_allowance ;
    max_calories ;
    max_vitamin_A ;
    -zero_matrix ;
    -0 ;
    0 ;
    -0 ;
];

c = price;
Aeq = [];
beq = [];

[x, fval, exitflag, output, lambda] = linprog(c, A, b, Aeq, beq);

%% Output

fprintf('The optimal cost is $%f / day\n', fval);
for i=1:length(food)
    food_name = food{i};
    food_required_measure = x(i)*food_measures(i);
    food_required_measure_units = food_measures_units{i};
    display_string = [food_name ' required amount is ' sprintf('%.2f', food_required_measure) ' ' food_required_measure_units];
    disp(display_string);
end