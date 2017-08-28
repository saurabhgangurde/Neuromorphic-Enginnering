%% Q1 

%% Q1 Part-A


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

for k=1:1:Ns

    tm=find(myPoissonSpikeTrain(k,:)==1)*0.1*ms;
    Iapp_synopse=zeros(size(t));

        for j=1:size(t,2)
            temp=0;
           for i=1:size(tm,2)

               if t(j)>tm(i)
                   temp=temp+exp((tm(i)-t(j))/tau)-exp((tm(i)-t(j))/taus);
               end
               

           end
           Iapp_synopse(j)=temp;

        end
     Iapp_global=Iapp_global+(Wo+sigma_w*randn())*Iapp_synopse;
end

Iapp_global=Io*Iapp_global;

[V,U] = AEF(delta_t,T,Iapp_global,1);
plot(t,V);

%% Q1 Part-B

