function [ V,t,spikes] = LIF_dynamic( delta_t,T,N,fanout_matrix,Weights_matrix,delay_matrix,EL,gL,C,Vt,Iext)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    Io=1E-12;
    tau=15E-3;
    tau_s=tau/4;

    t=linspace(0,T,T/delta_t);
    V = zeros(N,size(t,2)); 
    V(:,1) = EL;                                          % initial condition
    F = @(I,r) (1/C)*(-gL*(r-EL)+I);                    % change the function as you desire
    spikes=zeros(N,T/delta_t);
    last_spike_time=-100*ones(size(V,1),1);
    Iapp=zeros(size(V,1),1);
    Isyn_t= @(we,tk,td,t) Io*we*(exp(-(t-tk-td)/tau)-exp(-(t-tk-td)/tau_s)).*(t>tk+td);
    Iapp(1:size(Iext,1))=Iext(:,1);
    for time_t=1:T/delta_t-1
        time_t
        k_1 = F(Iapp,V(:,time_t));
        V(:,time_t+1) = V(:,time_t) + k_1*delta_t;  % main equation
        time_t_V=V(:,time_t+1);
        spiking_neurons=find(time_t_V>Vt);

        time_t_V(time_t_V>Vt |last_spike_time+2E-3/delta_t>time_t )=EL;    %% refractory period involved

        V(:,time_t+1)=time_t_V;
        V(spiking_neurons,time_t)=70E-3;
        last_spike_time(spiking_neurons)=time_t;
        spikes(spiking_neurons,time_t)=1;

        Isyn=zeros(size(V,1),1);
        for i=1:N
            current_neuron_spikes=find(spikes(i,1:time_t)==1)*delta_t;
            for j=1:size(fanout_matrix(i,:),2)
                for k=1:size(current_neuron_spikes,2)
                    Isyn(fanout_matrix(i,j))=Isyn(fanout_matrix(i,j))+Isyn_t(Weights_matrix(i,j),current_neuron_spikes(k),...
                                                                delay_matrix(i,j),t(time_t));
                end
            end
        end
        Iapp(1:size(Iext,1))=Iext(:,time_t+1)+Isyn(1:size(Iext,1));
        Iapp(size(Iext,1)+1:end)=Isyn(size(Iext,1)+1:end);
    end

end

