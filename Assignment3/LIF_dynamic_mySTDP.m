function [ V,t,spikes,average_synaptic_strength] = LIF_dynamic_mySTDP( delta_t,T,N,fanout_matrix,Weights_matrix,delay_matrix,Fanin,EL,gL,C,Vt,Iext,Aup,Adown,STDP)

    n=0.8;
    Io=1E-12;
    tau=15E-3;
    tau_s=tau/4;
    tau_l=20E-3;

    t=linspace(0,T,T/delta_t);
    V = zeros(N,size(t,2)); 
    V(:,1) = EL;                                          % initial condition
    F = @(I,r) (1/C)*(-gL*(r-EL)+I);                    % change the function as you desire
    spikes=zeros(N,T/delta_t);
    last_spike_time=-100*ones(size(V,1),1);
    Iapp=zeros(size(V,1),1);
    Isyn_t= @(we,tk,td,t) Io*we*(exp(-(t-tk-td)/tau)-exp(-(t-tk-td)/tau_s)).*(t>tk+td);
    Iapp(1:size(Iext,1))=Iext(:,1);
    average_synaptic_strength=zeros(size(t));
    for time_t=1:T/delta_t-1    
        %time_t
        average_synaptic_strength(time_t)=mean(mean(Weights_matrix(1:N*0.8,:)));
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
            
            random=rand;
            if (STDP==1 && i<N*0.8 && last_spike_time(i)==time_t)
                % forward
                
                fanout=fanout_matrix(i,:);
                for j=1:size(fanout,2)
                    if(last_spike_time(fanout(j))>0)
                        t_j_last=last_spike_time(fanout(j))*delta_t;
                        delay_i_j=delay_matrix(i,j);
                        t_i_k=time_t*delta_t;
                        %if random >n
                        Weights_matrix(i,j)=Weights_matrix(i,j)*(1+Adown*...
                            exp(-(t_i_k+delay_i_j-t_j_last)/tau_l));
                        %end
                    end
                end
                
                
                % backward
                fanin=Fanin{i};
   
                for j=1:size(fanin,2)
                    if last_spike_time(fanin(j)) >0
                        t_i_k=time_t*delta_t;
                        fanout_index=find(fanout_matrix(fanin(j),:)==i);
                        t_j_spikes=find(spikes(fanin(j),:)==1)*delta_t;
                        for k=1:size(t_j_spikes,2)
                            t_j_last=t_j_spikes(k)*delta_t+delay_matrix(fanin(j),fanout_index);
                            if(t_j_last<t_i_k)
                                break
                            end
                        end
                        if random> n
                        Weights_matrix(fanin(j),fanout_index)=Weights_matrix(fanin(j),fanout_index)*...
                            (1+Aup*exp(-(t_i_k-t_j_last)/tau_l*50));
                        end

                    end
                end
            end
     
        end
   
        Iapp(1:size(Iext,1))=Iext(:,time_t+1)+Isyn(1:size(Iext,1));
        Iapp(size(Iext,1)+1:end)=Isyn(size(Iext,1)+1:end);
    end
end

