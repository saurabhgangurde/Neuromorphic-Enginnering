%% Q1 Representing synaptic connectivity and axonal delays

%% Part A
seed=200;
rng(seed);
ms=1E-3;
N=500;

%  creating network
fanout_matrix=zeros(50,N);
fanout_matrix(:,1:round(N*0.8))=randi([1,500],[50,round(N*0.8)]);
fanout_matrix(:,round(N*0.8)+1:end)=randi([1,round(N*0.8)],[50,N-round(N*0.8)]);
Fanout=num2cell(fanout_matrix,1);

Weights_matrix=3000*ones(50,N);
Weights_matrix(fanout_matrix>round(N*0.8))=-3000;
Weight=num2cell(Weights_matrix,1);

delay_matrix=randi([1,20],[50,N])*ms;
delay_matrix(fanout_matrix>round(N*0.8))=1*ms;
Delay=num2cell(delay_matrix,1);

% constants
delta_t=1*ms;
T=1000*ms;
t=linspace(0,T,T/delta_t);
Io=1E-12;
tau=15*ms;
tau_s=tau/4;
EL=-70*1E-3;
gL=30*1E-9;
Vt=20*1E-3;
C=300*1E-12;
Rp=2*ms;
ws=3000;

% % forming Iext matrix
lambda=100;
myPoissonSpikeTrain = rand(25, T/delta_t) < lambda*delta_t;
Iext_t= @(ts,t) Io*ws*(exp(-(t-ts)/tau)-exp(-(t-ts)/tau_s)).*(t>ts);
Iext=zeros(25,T/delta_t);
for i=1:25
    ts=find(myPoissonSpikeTrain(i,:)==1)*delta_t;
    for k=1:size(ts,2)
        Iext(i,:)=Iext(i,:)+Iext_t(ts(k),t);
    end

end

[V,t,spikes]=LIF_dynamic( delta_t,T,N,Fanout,Weight,Delay,EL,gL,C,Vt,Iext);
plotRaster(spikes,t);