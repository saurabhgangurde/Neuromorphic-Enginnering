N=1;
T=0.500;
delta_t= 0.01 * 10^-3;
M=ceil(T/delta_t);
input=zeros(1,M);
for i=6000:9000
    input(1,i)=15*10^-2;
end

%% Q.4a
[volt,m,n,h] = rk4_q4(delta_t,T,input);
x = 0:delta_t:T;


figure()

plot(x,volt)

