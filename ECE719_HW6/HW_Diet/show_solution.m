function show_solution(x,fval)

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

fprintf('The optimal cost is $%f / day\n', fval);
for i=1:length(food)
    food_name = food{i};
    food_required_measure = x(i)*food_measures(i);
    food_required_measure_units = food_measures_units{i};
    display_string = [food_name ' required amount is ' sprintf('%.2f', food_required_measure) ' ' food_required_measure_units];
    disp(display_string);
end