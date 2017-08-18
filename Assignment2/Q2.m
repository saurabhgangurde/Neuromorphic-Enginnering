%% Q1 

%% Q1 Part-A

seed=10;
rng(seed)
T=500;
delta_t=0.1;
steps=T/delta_t;
Ns=100;
lambda=1;

random_sample = poissrnd(lambda,Ns,steps);

random_sample_cumsum=cumsum(random_sample,2);

Io=1E-12;
Wo=250;
sigma_w=25;
tau=15;
taus=tau/4;
t=0:delta_t:T;
Iapp_global=zeros(size(t));
for k=1:1:Ns
    indices=find(random_sample_cumsum(k,:)<T);
    tm=random_sample_cumsum(k,indices);
    Iapp_synopse=zeros(size(t));

        for j=1:size(t,2)
            temp=0;
           for i=1:size(tm,2)

               if t(j)>tm(i)
                   temp=temp+exp((tm(i)-t(j))/tau)-exp((tm(i)-t(j))/taus);
               end
               Iapp_synopse(j)=temp;

           end

        end
     Iapp_global=Iapp_global+(Wo+sigma_w*randn())*Iapp_synopse;
end

Iapp_global=Io*Iapp_global;

[V,U] = AEF(delta_t*1E-3,T*1E-3,Iapp_global,1);
plot(t,V);

%% Q1 Part-B

