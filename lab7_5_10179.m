k=3;
L=2^k;
M=20000;
x=2*floor(L*rand(1,M))-L+1;
hist(x,(-L+1:2:L-1))
