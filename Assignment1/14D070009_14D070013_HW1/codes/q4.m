%% Q4 Spike energy based on Hodgkin-Huxley neuron model
%% Q4-part a solving differrence equations
N=1;
T=500;
C = 1;
ENa = 50;
EK = - 77;
EL = - 55;
gNa = 120;
gK = 36 ;
gL = 0.3;
%defining Iapplied as function of time
input=@(t) 15*(heaviside(t-60)-heaviside(t-90));


[volt,m,n,h,t] = rk4_q4(T,input);

figure()
plot(t,volt)
title('Neuron Voltage Vs Time');
xlabel('time(in Seconds)');ylabel('Voltage(in mili Volts)');

%% Q4-part b instaneous power dissipated in various ion channels
iNa=(volt-ENa)*gNa;
PNa=iNa.*(volt-ENa)*1E-9;

iK=(volt-ENa)*gK;
PK=iK.*(volt-EK)*1E-9;

iL=(volt-EL)*gL;
PL=iL.*(volt-EL)*1E-9;



%for one cycle of spike harcoding the time of spike
tmax=size(find(t<69.72),1);
tmin=find(t>57);
tmin=tmin(1);
figure()
plot(t(tmin:tmax),PNa(tmin:tmax),t(tmin:tmax),PK(tmin:tmax),t(tmin:tmax),PL(tmin:tmax));
title('ion Channel Power Vs Time');
xlabel('time(in mili Seconds)');ylabel('Power(in W)');
legend('PNa','PK','PL');

%% Q4-part b instaneous power dissipated in various ion channels
Itotal=input(t)-(iNa+iK+iL);

Ptotal=Itotal(tmin:tmax).*volt(tmin:tmax)*1E-9;
Ptotal_one_cycle=sum(Ptotal);
display(strcat('Q4 part b Ans:total power dissipated in one spike cycle(in W):',num2str(abs(Ptotal_one_cycle))));
        

