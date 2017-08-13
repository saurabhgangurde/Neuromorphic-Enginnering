%% Q3 Adaptive Exponential Integrate-and-Fire Model

%% Q3 part-a writing difference equations

display('difference equation for Izhikevich Model');
display('V(n+1)=1/C(−gL(V(n)−EL)+gL∆Texp(− U(n)+Iapp(n)+V(n)');
display('and');
display('U(n+1)=1/τw(a[V(n)−EL]−U(n))+U(n)');
%% Q3 part-b Steady state values
% solving for steady state
% for RS neurons
[C,gL,EL,vT,del_T,a,tau_w,b,Vr]=neuron_data_q3(1);
syms V U 
[sol_V,sol_U] = vpasolve([-gL*(V-EL)+(gL*del_T*exp((V-vT)/del_T)) == U , a*(V-EL) == U], [V,U] );
sol_V= double(sol_V);
sol_U=double(sol_U); 
V_steady_state = double(sol_V);                                          
U_steady_state = double(sol_U);                                          
display('for RS neurons');
display(strcat('steady state V= ',num2str(V_steady_state)));
display(strcat('steady state U= ',num2str(U_steady_state)));

% for IB neurons
[C,gL,EL,vT,del_T,a,tau_w,b,Vr]=neuron_data_q3(2);
syms V U 
[sol_V,sol_U] = vpasolve([-gL*(V-EL)+(gL*del_T*exp((V-vT)/del_T)) == U , a*(V-EL) == U], [V,U] );
sol_V= double(sol_V);
sol_U=double(sol_U); 
V_steady_state = double(sol_V);                                          
U_steady_state = double(sol_U);                                          
display('for RS neurons');
display(strcat('steady state V= ',num2str(V_steady_state)));
display(strcat('steady state U= ',num2str(U_steady_state)));

% for CH neurons
[C,gL,EL,vT,del_T,a,tau_w,b,Vr]=neuron_data_q3(3);
syms V U 
[sol_V,sol_U] = vpasolve([-gL*(V-EL)+(gL*del_T*exp((V-vT)/del_T)) == U , a*(V-EL) == U], [V,U] );
sol_V= double(sol_V);
sol_U=double(sol_U); 
V_steady_state = double(sol_V);                                          
U_steady_state = double(sol_U);                                          
display('for RS neurons');
display(strcat('steady state V= ',num2str(V_steady_state)));
display(strcat('steady state U= ',num2str(U_steady_state)));

%% Q2 part-c Transient solution for RS type neuron
N=3;
T=0.500;
delta_t= 0.1 * 10^-3;
M=T/delta_t;
input=zeros(N,M);
for i=1:N
    input(i,:)=(1.5+i)*100*10^-12;
end

[y,z] = euler_q3(delta_t,T,input,1);
x = 0:delta_t:T;


figure()
plot(x,y(1,:));
title('Neuron 1 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x,y(2,:));
title('Neuron 2 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x,y(3,:));
title('Neuron 3 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x(1:1000),y(1,1:1000),x(1:1000),y(2,1:1000),x(1:1000),y(3,1:1000));
title('Neuron (1,2,3) Voltage Vs Time(Zoomed in version)');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');
legend('N1','N2','N3');

%% Q2 part-c Transient solution for IB type neuron
N=3;
T=0.500;
delta_t= 0.1 * 10^-3;
M=T/delta_t;
input=zeros(N,M);
for i=1:N
    input(i,:)=(1.5+i)*100*10^-12;
end

[y,z] = euler_q3(delta_t,T,input,2);
x = 0:delta_t:T;



figure()
plot(x,y(1,:));
title('Neuron 1 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x,y(2,:));
title('Neuron 2 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x,y(3,:));
title('Neuron 3 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x(1:1000),y(1,1:1000),x(1:1000),y(2,1:1000),x(1:1000),y(3,1:1000));
title('Neuron (1,2,3) Voltage Vs Time(Zoomed in version)');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');
legend('N1','N2','N3');

%% Q2 part-c Transient solution for CH type neuron

N=3;
T=0.500;
delta_t= 0.1 * 10^-3;
M=T/delta_t;
input=zeros(N,M);
for i=1:N
    input(i,:)=(1.5+i)*100*10^-12;
end

[y,z] = euler_q3(delta_t,T,input,3);
x = 0:delta_t:T;



figure()
plot(x,y(1,:));
title('Neuron 1 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x,y(2,:));
title('Neuron 2 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x,y(3,:));
title('Neuron 3 Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');

figure()
plot(x(1:1000),y(1,1:1000),x(1:1000),y(2,1:1000),x(1:1000),y(3,1:1000));
title('Neuron (1,2,3) Voltage Vs Time(Zoomed in version)');
xlabel('time(in Seconds)');ylabel('Voltage(in Volts)');
legend('N1','N2','N3');
