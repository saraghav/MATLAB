function emp_risk = empirical_risk_hinge(y, x, w)

n = length(y);
risk_array = max(0, 1 - y .* (x*w));
emp_risk = sum(risk_array)/n;