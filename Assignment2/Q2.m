%% Q2 AEF neuron driven by multiple synapses

%% Q1 Part-A Weak Synapses


ms=1E-3;
T=500*ms;
delta_t=0.1*ms;
steps=T/delta_t;
Ns=100;
lambda=1;


myPoissonSpikeTrain = rand(Ns, steps) < lambda*delta_t;


Io=1E-12;
Wo=50;
sigma_w=5;
tau=25*ms;
taus=tau/4;
t=0:delta_t:T;
Iapp_global=zeros(size(t));

synapse_strengths=Wo+sigma_w*randn(1,Ns);

for k=1:1:Ns

    tm=find(myPoissonSpikeTrain(k,:)==1)*0.1*ms;
    Iapp_synapse=zeros(size(t));

        for j=1:size(t,2)
            temp=0;
           for i=1:size(tm,2)

               if t(j)>tm(i)
                   temp=temp+exp((tm(i)-t(j))/tau)-exp((tm(i)-t(j))/taus);
               end
               

           end
           Iapp_synapse(j)=temp;

        end
     Iapp_global=Iapp_global+synapse_strengths(k)*Iapp_synapse;
end

Iapp_global=Io*Iapp_global;

[V,U] = AEF(delta_t,T,Iapp_global,1);


figure();
plot(t*1E3,V);
xlabel('Time in mS');ylabel('Voltage in Volts');
title('Voltage Vs Time');

figure();
plot(t*1E3,Iapp_global*1E12);
xlabel('Time in mS');ylabel('Current in pA');
title('Current Vs Time');
%% Q1 Part-B Strong Synapses

ms=1E-3;
T=500*ms;
delta_t=0.1*ms;
steps=T/delta_t;
Ns=100;
lambda=1;


myPoissonSpikeTrain = rand(Ns, steps) < lambda*delta_t;


Io=1E-12;
Wo=250;
sigma_w=15;
tau=25*ms;
taus=tau/4;
t=0:delta_t:T;
Iapp_global=zeros(size(t));
synapse_strengths=Wo+sigma_w*randn(1,Ns);

for k=1:1:Ns

    tm=find(myPoissonSpikeTrain(k,:)==1)*0.1*ms;
    Iapp_synapse=zeros(size(t));

        for j=1:size(t,2)
            temp=0;
           for i=1:size(tm,2)

               if t(j)>tm(i)
                   temp=temp+exp((tm(i)-t(j))/tau)-exp((tm(i)-t(j))/taus);
               end
               

           end
           Iapp_synapse(j)=temp;

        end
     Iapp_global=Iapp_global+synapse_strengths(k)*Iapp_synapse;
end

Iapp_global=Io*Iapp_global;

[V,U] = AEF(delta_t,T,Iapp_global,1);


figure();
plot(t*1E3,V);
xlabel('Time in mS');ylabel('Voltage in Volts');
title('Voltage Vs Time');

figure();
plot(t*1E3,Iapp_global*1E12);
xlabel('Time in mS');ylabel('Current in pA');
title('Current Vs Time');