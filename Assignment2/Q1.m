%% Q1 

%% Q1 Part-A

seed=100;
rng(seed)
ms=1E-3;

T=500*ms;
delta_t=0.1*ms;
steps=T/delta_t;
lambda=10;

myPoissonSpikeTrain = rand(1, steps) < lambda*delta_t;

%% Q1 Part-B
Io=1E-12;
We=500;
tau=15*ms;
taus=tau/4;
t=0:delta_t:T;
tm=find(myPoissonSpikeTrain==1)*0.1*ms;
i_matrix=zeros(size(tm,2),size(t,2));

Iapp=zeros(size(t));

for j=1:size(t,2)
    temp=0;
   for i=1:size(tm,2)
      
       if (t(j)>tm(i))
           
           temp=temp+exp((tm(i)-t(j))/tau)-exp((tm(i)-t(j))/taus);
       end
          
   end

   Iapp(j)=temp;
    
end

Iapp=Io*We*Iapp;


[V,U] = AEF(delta_t,T,Iapp,1);

figure();
plot(t*1E3,V);
xlabel('Time in mS');ylabel('Voltage in Volts');
title('Voltage Vs Time');
figure();
plot(t(2:end)*1E3,myPoissonSpikeTrain);
xlabel('Time in mS');ylabel('Spike');
title('spike Vs Time');
figure();
plot(t*1E3,Iapp*1E12);
xlabel('Time in mS');ylabel('Current in pA');
title('Current Vs Time');