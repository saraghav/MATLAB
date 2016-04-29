function prob = prob_algo(beta)

n1 = evalin('base', 'n1');
n2 = evalin('base', 'n2');

prob = 1 - 6*log(n2)*(n1+n2)^(2-2*beta) - n2^(2-2*sqrt(beta));