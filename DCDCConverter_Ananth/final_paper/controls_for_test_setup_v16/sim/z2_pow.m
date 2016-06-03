function z_exp = z_pow(coeff,pow_arr)

% z_pow(coeff_arr, exponent_array)
% e.g. if you want a*z^-1 + b*z^-5 use:
% z_pow( [a b], [-1 -5] );
% REQUIRES global Ts2

global Ts2;

len = length(coeff);
z_exp = tf(0,1,Ts2);

for i=1:len
    z_exp = z_exp + coeff(i)*tf([1 0],1,Ts2)^pow_arr(i);
end