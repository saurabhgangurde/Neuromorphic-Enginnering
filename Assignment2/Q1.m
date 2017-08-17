%% Q1 

%% Q1 Part-A

seed=10;
rng(seed)
T=500;
delta_t=0.1;
steps=T/delta_t;
lambda=10;

random_sample = poissrnd(lambda,1,steps);

random_sample_cumsum=cumsum(random_sample);

indices=find(random_sample_cumsum<T);

poisson_random_spikes=zeros(1,500);
poisson_random_spikes(random_sample_cumsum(indices))=1;

%% Q1 Part-B
Io=1E-12;
We=500;
tau=15;
taus=tau/4;
t=0:delta_t:T;
tm=random_sample_cumsum(indices);
i_matrix=zeros(size(tm,2),size(t,2));

Iapp=zeros(size(t));

for j=1:size(t,2)
    temp=0;
   for i=1:size(tm,2)
       
       if t(j)>tm(i)
           temp=temp+exp((tm(i)-t(j))/tau)-exp((tm(i)-t(j))/taus);
       end
       Iapp(j)=temp;
   
   end
    
end
Iapp=Io*We*Iapp;


[V,U] = AEF(delta_t*1E-3,T*1E-3,Iapp,1);

plot(t,V);