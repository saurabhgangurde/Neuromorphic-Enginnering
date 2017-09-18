%% Q3 Dynamics of smaller networks

%% Part A
seed=200;
rng(seed);
ms=1E-3;
N=200;
fanout_ratio=N/10;
gamma=1;
w_global=2000;
%  creating network
fanout_matrix=zeros(fanout_ratio,N);
fanout_matrix(:,1:round(N*0.8))=randi([1,N],[fanout_ratio,round(N*0.8)]);
fanout_matrix(:,round(N*0.8)+1:end)=randi([1,round(N*0.8)],[fanout_ratio,N-round(N*0.8)]);
Fanout=num2cell(fanout_matrix,1);

Weights_matrix=gamma*w_global*ones(fanout_ratio,N);
Weights_matrix(:,round(N*0.8)+1:end)=-w_global;
Weight=num2cell(Weights_matrix,1);

delay_matrix=randi([1,20],[fanout_ratio,N])*ms;
delay_matrix(:,round(N*0.8)+1:end)=1*ms;
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

Re_temp=sum(spikes(1:round(N*0.8),:),1);
Ri_temp=sum(spikes(round(N*0.8)+1:end,:),1);
Re=zeros(1,T/delta_t-10*ms/delta_t);
Ri=zeros(1,T/delta_t-10*ms/delta_t);
for i=1:T/delta_t-10*ms/delta_t
    Re(i)=sum(Re_temp(i:i+10*ms/delta_t));
    Ri(i)=sum(Ri_temp(i:i+10*ms/delta_t));
end

figure(2);
plot(t(1:T/delta_t-10*ms/delta_t),Re,t(1:T/delta_t-10*ms/delta_t),Ri);
