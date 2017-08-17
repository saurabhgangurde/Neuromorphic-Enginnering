%% Q1 

%% Q1 Part-A

T=500;
delta_t=0.1;
steps=T/delta_t;
lambda=10;

random_sample = poissrnd(lambda,1,steps);

random_sample_cumsum=cumsum(random_sample);

indices=find(random_sample_cumsum<steps);

poisson_random_spikes=zeros(1,steps);
poisson_random_spikes(random_sample_cumsum(indices))=1;

%% Q1 Part-B
Io=1E-12;
We=500;
tau=15;
taus=tau/4;
t=[1:1:5000]*delta_t;
tm=t(indices);
i_matrix=zeros(size(tm,2),size(t,2));

for i=1:size(tm,2)
   
    i_matrix(i,:)=exp(-1*(t-tm(i))/tau)-exp(-1*(t-tm(i))/taus);
    
end

Iapp=Io*We*sum(i_matrix);

neuron_type=[1];
[t,v] = AEF(delta_t,T,Iapp,neuron_type);
plot(t,v);