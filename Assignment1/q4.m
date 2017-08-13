N=1;
T=500;

input=@(t) 15*(heaviside(t-60)-heaviside(t-90));

%% Q.4a
[volt,m,n,h,x] = rk4_q4(T,input);

figure()

plot(x,volt)





