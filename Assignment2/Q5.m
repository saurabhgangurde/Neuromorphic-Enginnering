%% Q5 Discriminating stimuli with similar statistical characteristics

%% Q5 part A geneareting S1,S2 and it's response
ms=1E-3;
T=500*ms;
delta_t=0.1*ms;
steps=T/delta_t;
Ns=100;
lambda=1;


myPoissonSpikeTrain_S1 = rand(Ns, steps) < lambda*delta_t;


Io=1E-12;
Wo=200;
sigma_w=20;
tau=25*ms;
taus=tau/4;
t=0:delta_t:T;
Iapp_global_S1=zeros(size(t));
synapse_strengths_S1=Wo+sigma_w*randn(1,Ns);
Iapp_synapse_S1=zeros(Ns,size(t,2));

for k=1:1:Ns

    tm=find(myPoissonSpikeTrain_S1(k,:)==1)*0.1*ms;
    

        for j=1:size(t,2)
            temp=0;
           for i=1:size(tm,2)

               if t(j)>tm(i)
                   temp=temp+exp((tm(i)-t(j))/tau)-exp((tm(i)-t(j))/taus);
               end
               

           end
           Iapp_synapse_S1(k,j)=temp;

        end
     Iapp_global_S1=Iapp_global_S1+synapse_strengths_S1(k)*Iapp_synapse_S1(k,:);
end

Iapp_global_S1=Io*Iapp_global_S1;

[V_S1,U_S1] = AEF(delta_t,T,Iapp_global_S1,1);


figure();
subplot(2,1,1);
plot(t*1E3,V_S1);
xlabel('Time in mS');ylabel('Voltage in Volts');
title('Voltage Vs Time');

subplot(2,1,2);
plot(t*1E3,Iapp_global_S1*1E12);
xlabel('Time in mS');ylabel('Current in pA');
title('Current Vs Time');

% respond to S2

myPoissonSpikeTrain_S2 = rand(Ns, steps) < lambda*delta_t;
Iapp_global_S2=zeros(size(t));
synapse_strengths_S2=Wo+sigma_w*randn(1,Ns);
Iapp_synapse_S2=zeros(Ns,size(t,2));

for k=1:1:Ns

    tm=find(myPoissonSpikeTrain_S2(k,:)==1)*0.1*ms;
    

        for j=1:size(t,2)
            temp=0;
           for i=1:size(tm,2)

               if t(j)>tm(i)
                   temp=temp+exp((tm(i)-t(j))/tau)-exp((tm(i)-t(j))/taus);
               end
               

           end
           Iapp_synapse_S2(k,j)=temp;

        end
     Iapp_global_S2=Iapp_global_S2+synapse_strengths_S2(k)*Iapp_synapse_S2(k,:);
end

Iapp_global_S2=Io*Iapp_global_S2;

[V_S2,U_S2] = AEF(delta_t,T,Iapp_global_S2,1);


figure();
subplot(2,1,1);
plot(t*1E3,V_S2);
xlabel('Time in mS');ylabel('Voltage in Volts');
title('Voltage Vs Time');

subplot(2,1,2);
plot(t*1E3,Iapp_global_S2*1E12);
xlabel('Time in mS');ylabel('Current in pA');
title('Current Vs Time');

%% Q5 part B Removing S2 spike
Vold=V_S2;
tspikes=find(V_S2==0.05)*0.1*ms;
tspikes=tspikes(2:end);
gamma=1;
for iteration=1:100
    
    delta_w=zeros(1,Ns);
    delta_tk=zeros(1,Ns);
    for k=1:Ns
        
        tm=find(myPoissonSpikeTrain_S2(k,:)==1)*0.1*ms;
        indices=find(tm<tspikes(1));
        if size(indices,2)~=0
            delta_tk(k)=tspikes(1)-tm(indices(end));
            delta_w(k)=-1*synapse_strengths_S2(k)*gamma*(exp(-delta_tk(k)/tau)-exp(-delta_tk(k)/taus));            
            
        end
            
    end
    
    synapse_strengths_S2=synapse_strengths_S2+delta_w;
    Iapp=diag(synapse_strengths_S2)*Iapp_synapse_S2;
    Iapp=Io*sum(Iapp);
    [V,U] = AEF(delta_t,T,Iapp,1);
    
    tspikes=find(V==0.05)*0.1*ms;
    tspikes=tspikes(2:end);

   
    spike=find(V==0.05);
    if size(spike,2)==1
        break
    end
end

figure();
plot(synapse_strengthsold);
xlabel('Synapse Number');ylabel('Synapse Strength');
title(sprintf('Synapse Strengthlearnedd',iteration));
    
%% Q5 part C Distinguishing S1 from S2

Iapp=diag(synapse_strengths_S2)*Iapp_synapse_S1;
Iapp=Io*sum(Iapp);
[V,U] = AEF(delta_t,T,Iapp,1);

figure();
plot(t*1E3,V,t*1E3,V_S2);
xlabel('Time in mS');ylabel('Voltage in Volts');
title('Weights of S2 and current of S1');
legend('cross weight response S1','Response S2');
%% Q5 part D Distinguishing S2 from S1

Vold=V_S1;
tspikes=find(V_S1==0.05)*0.1*ms;
tspikes=tspikes(2:end);
gamma=1;
for iteration=1:100
    
    delta_w=zeros(1,Ns);
    delta_tk=zeros(1,Ns);
    for k=1:Ns
        
        tm=find(myPoissonSpikeTrain_S1(k,:)==1)*0.1*ms;
        indices=find(tm<tspikes(1));
        if size(indices,2)~=0
            delta_tk(k)=tspikes(1)-tm(indices(end));
            delta_w(k)=-1*synapse_strengths_S1(k)*gamma*(exp(-delta_tk(k)/tau)-exp(-delta_tk(k)/taus));            
            
        end
            
    end
    
    synapse_strengths_S1=synapse_strengths_S1+delta_w;
    Iapp=diag(synapse_strengths_S1)*Iapp_synapse_S1;
    Iapp=Io*sum(Iapp);
    [V,U] = AEF(delta_t,T,Iapp,1);
    
    tspikes=find(V==0.05)*0.1*ms;
    tspikes=tspikes(2:end);

    
    spike=find(V==0.05);
    if size(spike,2)==1
        break
    end
end

Iapp=diag(synapse_strengths_S1)*Iapp_synapse_S2;
Iapp=Io*sum(Iapp);
[V,U] = AEF(delta_t,T,Iapp,1);

figure();
plot(t*1E3,V,t*1E3,V_S1);
xlabel('Time in mS');ylabel('Voltage in Volts');
title('Weights of S1 and current of S2');
legend('cross weight response S2','Response S1');

