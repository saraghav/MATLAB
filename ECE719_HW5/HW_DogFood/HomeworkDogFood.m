% Homework DogFood

A = [  8  3 ;
      11 15 ;
      25  6 ];
  
b = [  48 ;
      165 ;
      150 ];

f = [ 1.2e-3 ;
      1e-3   ];
  
result = linprog(f, -A, -b, [0 0], 0, [0 0]');