%% C dV (t)/dt = -gL(V (t) - EL) + Iapp(t)

C=300 *10^-12;
gL = 30 * 10^-9;
VT = 20*10^-3 ;
EL = -70 *10^-3;
Ic=(VT-EL)*gL;


%% input vector n X m
N=10;
T=0.500;
delta_t= 0.1 * 10^-3;
M=T/delta_t;
input=zeros(N,M);

for i=1:N
    input(i,:)=(1+i*0.1)*Ic;
end

%% Q 1b
x = 0:delta_t:T;
y = runge_kutta_second_order(delta_t,T,input,EL,gL,C);

%% Q 1c
figure()
plot(x,y(2,:),x,y(4,:),x,y(6,:),x,y(8,:));
%plot(x,y(2,:));
legend('N2','N4','N6','N8');


%% Q 1d
interval=[];

for j=1:size(y,1)
    for i=2:size(y,2)
        if y(j,i)== EL
            interval=[interval i*delta_t];
            break
        end
    end
end
figure(2)
plot(interval,'linewidth',3.0);

            