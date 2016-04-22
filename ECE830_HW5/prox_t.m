function w_k = prox_t(y, x, w_km1, t, lambda)

est_err = y - x'*w_km1;
v_temp_0 = bsxfun(@times, est_err', x);
v_temp_1 = sum(v_temp_0, 2);
v = w_km1 + 2*t*v_temp_1;
w_k = zeros(size(w_km1));

p = length(w_km1);
for j=1:p
    if abs(v(j)) <= t*lambda
        w_k(j) = 0;
    else
        w_k(j) = v(j) - t*lambda*sign(v(j));
    end
end