%% Q4 Adjusting the weights to remove all spike responses

%% Q4 part A Stimulus Generation
ms=1E-3;
T=500*ms;
delta_t=0.1*ms;
steps=T/delta_t;
Ns=100;
lambda=1;


myPoissonSpikeTrain = rand(Ns, steps) < lambda*delta_t;


Io=1E-12;
Wo=250;
sigma_w=25;
tau=25*ms;
taus=tau/4;
t=0:delta_t:T;
Iapp_global=zeros(size(t));
synapse_strengths=Wo+sigma_w*randn(1,Ns);

Iapp_synapse=zeros(Ns,size(t,2));

for k=1:1:Ns

    tm=find(myPoissonSpikeTrain(k,:)==1)*0.1*ms;
    

        for j=1:size(t,2)
            temp=0;
           for i=1:size(tm,2)

               if t(j)>tm(i)
                   temp=temp+exp((tm(i)-t(j))/tau)-exp((tm(i)-t(j))/taus);
               end
               

           end
           Iapp_synapse(k,j)=temp;

        end
     Iapp_global=Iapp_global+synapse_strengths(k)*Iapp_synapse(k,:);
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
Vold=V;
Iold=Iapp_global;
synapse_strengthsold=synapse_strengths;
%% Q4 part B Learning part
tspikes=find(V==0.05)*0.1*ms;
tspikes=tspikes(2:end);
gamma=1;
for iteration=1:100
    
    delta_w=zeros(1,Ns);
    delta_tk=zeros(1,Ns);
    for k=1:Ns
        
        tm=find(myPoissonSpikeTrain(k,:)==1)*0.1*ms;
        indices=find(tm<tspikes(1));
        if size(indices,2)~=0
            delta_tk(k)=tspikes(1)-tm(indices(end));
            delta_w(k)=-1*synapse_strengths(k)*gamma*(exp(-delta_tk(k)/tau)-exp(-delta_tk(k)/taus));            
            
        end
            
    end
    
    synapse_strengths=synapse_strengths+delta_w;
    Iapp=diag(synapse_strengths)*Iapp_synapse;
    Iapp=Io*sum(Iapp);
    [V,U] = AEF(delta_t,T,Iapp,1);
    
    tspikes=find(V==0.05)*0.1*ms;
    tspikes=tspikes(2:end);
    


    figure();
    subplot(2,1,1);
    plot(t*1E3,V,t*1E3,Vold);
    xlabel('Time in mS');ylabel('Voltage in Volts');
    title(sprintf('Voltage Vs Time(iteration %d)',iteration));
    legend('Learned','old');

    
    subplot(2,1,2);
    plot(delta_tk,delta_w,'o');
    xlabel('Time in mS');ylabel('Change in Synapse Strength');
    title(sprintf('deltaw Vs deltatk(iteration %d)',iteration));
    
    spike=find(V==0.05);
    if size(spike,2)==1
        break
    end
end
        
 fprintf('Number of iteration needed =%d',iteration);       