function X_k = prox_t(M, X_km1, t, lambda)

R_omega = (M~=0);
Q = X_km1 - t * R_omega.*(X_km1 - M);

[U, Sigma, V] = svd(Q);

Sigma2 = zeros(size(Sigma));

p = size(Sigma,1);
for j=1:p
    if abs(Sigma(j,j)) > t*lambda
        Sigma2(j,j) = Sigma(j,j) - t*lambda*sign(Sigma(j,j));
    end
end

X_k = U*Sigma2*V';