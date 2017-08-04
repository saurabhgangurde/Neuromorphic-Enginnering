N=3;
T=0.500;
delta_t= 0.1 * 10^-3;
M=T/delta_t;
input=zeros(N,M);
for i=1:N
    input(i,:)=(1.5+i)*100*10^-12;
end


%% Q.3a
[y,z] = euler_q3(delta_t,T,input,3);
x = 0:delta_t:T;

figure()
plot(x,y(1,:),x,y(2,:),x,y(3,:));
