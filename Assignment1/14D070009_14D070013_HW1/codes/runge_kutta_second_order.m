function [y] = runge_kutta_second_order(delta_t,T,input,EL,gL,C)
    x = 0:delta_t:T;                                         % Calculates upto y(3)
    y = zeros(size(input,1),size(x,2)); 
    y(:,1) = EL;                                          % initial condition
    F_xy = @(t,r) (1/C)*(-gL*(r-EL)+t);                    % change the function as you desire
    
    for i=1:size(x,2)-1                              % calculation loop for different time intervals
            k_1 = F_xy(input(:,i),y(:,i));
            k_2 = F_xy(input(:,i),y(:,i)+delta_t*k_1);

            y(:,i+1) = y(:,i) + (1/2)*(k_1+2*k_2)*delta_t;  % main equation
            
            
            % determining which neuron will spike at ith interval
            temp=y(:,i+1);
            index=find(temp>20*10^-3);
            temp(temp>20*10^-3)=EL;
            y(:,i+1)=temp;
            y(index,i)=50E-3;
                

    end
end