%% Q1 Representing synaptic connectivity and axonal delays

%% Part A
ms=1E-3;
N=5;
Fanout=cell(1,N);
Weight=cell(1,N);
Delay=cell(1,N);

%  creating network
Fanout{1}=[4 5];Weight{1}=[3000 3000];Delay{1}=[1*ms 5*ms];
Fanout{2}=[4 5];Weight{2}=[3000 3000];Delay{2}=[5*ms 5*ms];
Fanout{3}=[4 5];Weight{3}=[3000 3000];Delay{3}=[9*ms 1*ms];

%% Part B case 1

% constants
delta_t=0.1*ms;
T=100*ms;
t=linspace(0,T,T/delta_t);
Io=1E-12;
tau=15*ms;
tau_s=tau/4;
EL=-70*1E-3;
gL=30*1E-9;
Vt=20*1E-3;
C=300*1E-12;
Rp=2*ms;
input_time=cell(1,N);
spike_time=cell(1,N);
Iapp=zeros(N,T/delta_t);

input_time{1}=[0];input_time{2}=[4*ms];input_time{3}=[8*ms];

% forming Iapp matrix
for i=1:N
    for j=1:size(input_time{i},2)
        Iapp(i,input_time{i}(j)/delta_t+1:(input_time{i}(j)+1*ms)/delta_t)=50*1E-9;
    end
end

[V,t]=LIF( delta_t,T,Iapp(1:3,:),EL,gL,C,Vt);

% finding spike times
spike_time{1}=find(V(1,:)==70E-3)*delta_t;spike_time{2}=find(V(2,:)==70E-3)*delta_t;spike_time{3}=find(V(3,:)==70E-3)*delta_t;

% finding synaptic current
Isyn=zeros(N,T/delta_t);

Isyn_t= @(we,tk,td,t) Io*we*(exp(-(t-tk-td)/tau)-exp(-(t-tk-td)/tau_s)).*(t>tk+td);
for i=1:N
    fanout_nodes=Fanout{i};
    for j=1:size(fanout_nodes,2)
        for k=1:size(spike_time{i},2)
            Isyn(fanout_nodes(j),:)=Isyn(fanout_nodes(j),:)+Isyn_t(Weight{i}(j),spike_time{i}(k),Delay{i}(j),t);
        end
    end
end

[V_2_layer,t]=LIF( delta_t,T,Isyn(4:5,:),EL,gL,C,Vt);

figure(1)
plot(t,Isyn(4:5,:),'linewidth',2);
title('Synaptic Current Vs Time');
xlabel('Time in S');ylabel('Current in A');
legend('a','b');
figure(2)
plot(t,V,t,V_2_layer,'linewidth',2);
title('Neuron Voltage Vs Time');
xlabel('Time in S');ylabel('Voltage in V');
legend('b','c','d','a','b');
%% Part B case 2
input_time{1}=[7*ms];input_time{2}=[3*ms];input_time{3}=[0*ms];
Iapp=zeros(N,T/delta_t);

% forming Iapp matrix
for i=1:N
    for j=1:size(input_time{i},2)
        Iapp(i,input_time{i}(j)/delta_t+1:(input_time{i}(j)+1*ms)/delta_t)=50*1E-9;
    end
end

[V,t]=LIF( delta_t,T,Iapp(1:3,:),EL,gL,C,Vt);

% finding spike times
spike_time{1}=find(V(1,:)==70E-3)*delta_t;spike_time{2}=find(V(2,:)==70E-3)*delta_t;spike_time{3}=find(V(3,:)==70E-3)*delta_t;

% finding synaptic current
Isyn=zeros(N,T/delta_t);

Isyn_t= @(we,tk,td,t) Io*we*(exp(-(t-tk-td)/tau)-exp(-(t-tk-td)/tau_s)).*(t>tk+td);
for i=1:N
    fanout_nodes=Fanout{i};
    for j=1:size(fanout_nodes,2)
        for k=1:size(spike_time{i},2)
            Isyn(fanout_nodes(j),:)=Isyn(fanout_nodes(j),:)+Isyn_t(Weight{i}(j),spike_time{i}(k),Delay{i}(j),t);
        end
    end
end

[V_2_layer,t]=LIF( delta_t,T,Isyn(4:5,:),EL,gL,C,Vt);

figure(3)
plot(t,Isyn(4:5,:),'linewidth',2);
title('Synaptic Current Vs Time');
xlabel('Time in S');ylabel('Current in A');
legend('a','b');
figure(4)
plot(t,V,t,V_2_layer,'linewidth',2);
title('Neuron Voltage Vs Time');
xlabel('Time in S');ylabel('Voltage in V');
legend('b','c','d','a','b');