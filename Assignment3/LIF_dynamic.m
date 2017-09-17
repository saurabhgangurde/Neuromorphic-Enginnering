function [ y,x,spikes] = LIF_dynamic( delta_t,T,N,Fanout,Weight,Delay,EL,gL,C,Vt,Iext)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    x = linspace(0,T,T/delta_t);                                         % Calculates upto y(3)
    y = zeros(N,size(x,2)); 
    y(:,1) = EL;                                          % initial condition
    F_xy = @(t,r) (1/C)*(-gL*(r-EL)+t);                    % change the function as you desire
    
    spikes_time=-100*ones(size(y,1),1);
    spikes=zeros(N,T/delta_t);
    Iapp=zeros(N,T/delta_t);
    Iapp(1:size(Iext,1),:)=Iext;
    
    Io=1E-12;
    tau=15E-3;
    tau_s=tau/4;
    
    Isyn_t= @(we,tk,td,t) Io*we*(exp(-(t-tk-td)/tau)-exp(-(t-tk-td)/tau_s)).*(t>tk+td);

    for iter=1:size(x,2)-1                            % calculation loop for different time intervals
              
            k_1 = F_xy(Iapp(:,iter),y(:,iter));
            k_2 = F_xy(Iapp(:,iter),y(:,iter)+delta_t*k_1);

            y(:,iter+1) = y(:,iter) + (1/2)*(k_1+2*k_2)*delta_t;  % main equation
            
            
            % determining which neuron will spike at ith interval
            temp=y(:,iter+1);
            index=find(temp>Vt);
            
            
            temp(temp>Vt )=EL;    %% refractory period involved
            spikes_time(index)=iter;
            
            y(:,iter+1)=temp;
            y(index,iter)=70E-3;
            spikes(index,iter)=1;
            % modified Iapp calculation
            
            Isyn=zeros(N,T/delta_t);
            for i=1:N
                fanout_nodes=Fanout{i};
                for j=1:size(fanout_nodes,2)
                    temp_spike_time=find(spikes(i,:)==1)*delta_t;
                    for k=1:size(temp_spike_time,2)
                        Isyn(fanout_nodes(j),iter+1)=Isyn(fanout_nodes(j),iter+1)+Isyn_t(Weight{i}(j),temp_spike_time(k),Delay{i}(j),x(iter+1));
                    end
                end
            end
            Iapp(:,iter+1)=Iapp(:,iter+1)+Isyn(:,iter+1);    
                

    end

end

