%% Q1 Leaky Integrate and Fire Model
%% Q1-part a steady state voltage expression

%C dV (t)/dt = -gL(V (t) - EL) + Iapp(t)
display('Q1 part a Ans:');
display('Steady state voltage expression: V=Ic/gl+El');

%% Q1-part b- Creating Framework
%defining constants
C=300 *10^-12;
gL = 30 * 10^-9;
VT = 20*10^-3 ;
EL = -70 *10^-3;
Ic=(VT-EL)*gL;


% input vector n X m
% defining transient parameters
N=10;
T=0.500;
delta_t= 0.1 * 10^-3;
M=T/delta_t;
input=zeros(N,M);

% defining current as mentioned in problem statement
for i=1:N
    input(i,:)=(1+i*0.1)*Ic;
end

x = 0:delta_t:T;
y = runge_kutta_second_order(delta_t,T,input,EL,gL,C);

%% Q1-part c- plotting Voltages of various neurons
%We are setting artificial spike before resetting voltages for better
%visualisation
figure()
plot(x,y(2,:));
title('Neuron 2 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x,y(4,:));
title('Neuron 4 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x,y(6,:));
title('Neuron 6 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x,y(8,:));
title('Neuron 8 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x(1:500),y(2,1:500),x(1:500),y(4,1:500),x(1:500),y(6,1:500),x(1:500),y(8,1:500));
title('Neuron (2,4,6,8) Voltage Vs Time(Zoomed in version)');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');
legend('N2','N4','N6','N8');

%% Q1-part d Average time between two spikes
interval=[];
Avg_interval=[];

for j=1:size(y,1)
    prev_spike=0;
    for i=2:size(y,2)
        if y(j,i)== EL
            
            interval=[interval (i-prev_spike)*delta_t];
            prev_spike=i;
            break
        end
    end
    Avg_interval=[Avg_interval mean(interval)];
end
figure();
Ik=1:1:10;
plot(Ik,Avg_interval,'-o','linewidth',2.0);
title('Average time between spikes Vs Current');
ylabel('time(in Seconds)');xlabel('Current');

            