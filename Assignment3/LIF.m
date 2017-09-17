function [ y,x] = LIF( delta_t,T,input,EL,gL,C,Vt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    x = linspace(0,T,T/delta_t);                                         % Calculates upto y(3)
    y = zeros(size(input,1),size(x,2)); 
    y(:,1) = EL;                                          % initial condition
    F_xy = @(t,r) (1/C)*(-gL*(r-EL)+t);                    % change the function as you desire
    
    spikes_time=-100*ones(size(y,1),1);
    for i=1:size(x,2)-1                            % calculation loop for different time intervals
              
            k_1 = F_xy(input(:,i),y(:,i));
            k_2 = F_xy(input(:,i),y(:,i)+delta_t*k_1);

            y(:,i+1) = y(:,i) + (1/2)*(k_1+2*k_2)*delta_t;  % main equation
            
            
            % determining which neuron will spike at ith interval
            temp=y(:,i+1);
            index=find(temp>Vt);
            
            temp(temp>Vt |spikes_time+1E-3/delta_t>i)=EL;
            spikes_time(index)=i;
            
            y(:,i+1)=temp;
            y(index,i)=70E-3;
                

    end

end

