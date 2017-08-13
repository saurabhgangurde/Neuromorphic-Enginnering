%% Q2 Izhikevich Model
%% Q2 part-a steady state values
% solving for steady state
% for RS neurons
[C,kz,Er,Et,a,b,c,d,v_peak]=neuron_data(1);
polynom = [kz/c,-1-((Er+Et)*kz/b),Er+Er*Et*kz/b];
root_temp=roots(polynom);
V_steady_state=root_temp(2);                                  
U_steady_state= (root_temp(2)-Er)*b; 
display('Q2 part a Ans:');
display('for RS neurons');
display(strcat('steady state V= ',num2str(V_steady_state)));
display(strcat('steady state U= ',num2str(U_steady_state)));

% for IB neurons
[C,kz,Er,Et,a,b,c,d,v_peak]=neuron_data(2);
polynom = [kz/c,-1-((Er+Et)*kz/b),Er+Er*Et*kz/b];
root_temp=roots(polynom);
V_steady_state=root_temp(2);                                  
U_steady_state= (root_temp(2)-Er)*b; 
display('for IB neurons');
display(strcat('steady state V= ',num2str(V_steady_state)));
display(strcat('steady state U= ',num2str(U_steady_state)));

% for CH neurons
[C,kz,Er,Et,a,b,c,d,v_peak]=neuron_data(3);
polynom = [kz/c,-1-((Er+Et)*kz/b),Er+Er*Et*kz/b];
root_temp=roots(polynom);
V_steady_state=root_temp(2);                                  
U_steady_state= (root_temp(2)-Er)*b; 
display('for CH neurons');
display(strcat('steady state V= ',num2str(V_steady_state)));
display(strcat('steady state U= ',num2str(U_steady_state)));

%% Q2 part-b Writing Difference equations

display('Q2 part b Ans:');
display('difference equation for Izhikevich Model');
display('V(n+1)=(1/C(kz(V(n)−Er)(V(n)−Et)−U(n)+I app(n))*delta_t+V(n)');
display('and');
display('U(n+1)=(a[b(V(n)−Er) − U (n)])*delta_t+U(n)');

%% Q2 part-c Transient solution for RS type neuron
N=3;
T=0.500;
delta_t= 0.1 * 10^-3;
M=T/delta_t;
input=zeros(N,M);

for i=1:N
    input(i,:)=(4+i)*100*10^-12;
end

x = 0:delta_t:T;
[y,z] = rk4(delta_t,T,input,1);


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
    input(i,:)=(4+i)*100*10^-12;
end

x = 0:delta_t:T;
[y,z] = rk4(delta_t,T,input,2);


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
    input(i,:)=(4+i)*100*10^-12;
end

x = 0:delta_t:T;
[y,z] = rk4(delta_t,T,input,3);


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