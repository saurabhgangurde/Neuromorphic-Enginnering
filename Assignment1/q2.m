N=3;
T=0.500;
delta_t= 0.1 * 10^-3;
M=T/delta_t;
input=zeros(N,M);

for i=1:N
    input(i,:)=(4+i)*100*10^-12;
end
%%% specify neuron type as 1 2 3
%% Q 1b
x = 0:delta_t:T;
[y,z] = rk4(delta_t,T,input,3);


figure()
plot(x,y(1,:),x,y(2,:),x,y(3,:));
%plot(x,y(2,:));
legend('N400','N500','N600');