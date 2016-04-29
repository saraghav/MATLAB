% kullback leibler divergences

D_p0p1 = @(L0, L1) -(L0-L1) + L0 * log(L0/L1);
D_p1p0 = @(L0, L1) -(L1-L0) + L1 * log(L1/L0);

L0 = 10;
L1 = 20;

D_p0p1(L0, L1)

D_p1p0(L0, L1)