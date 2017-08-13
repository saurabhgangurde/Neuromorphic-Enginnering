function [ V,U ] = euler_q3( delta_t,T,input,neuron_type )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[C,gL,EL,vT,del_T,a,tau_w,b,Vr]=neuron_data_q3(neuron_type);

    x = 0:delta_t:T;                                         % Calculates upto y(3)
    
    
    syms V U 
    [sol_V,sol_U] = vpasolve([-gL*(V-EL)+(gL*del_T*exp((V-vT)/del_T)) == U , a*(V-EL) == U], [V,U] );

    sol_V= double(sol_V);
    sol_U=double(sol_U); 
    
    V = zeros(size(input,1),size(x,2)); 
    U = zeros(size(input,1),size(x,2)); 
    
    V(:,1) = double(sol_V);                                          % initial condition
    U(:,1) = double(sol_U);                                          % initial condition

    F_xy = @(I,v,u) (1/C)*(-gL*(v-EL)+gL*del_T*exp((v-vT)/del_T)-u+I);% change the function as you desire
    G_xy = @(I,v,u) (1/tau_w)*(a*(v-EL)-u);
    
    %% loop for V calc
for i=1:size(x,2)-1 
           
            k0=F_xy(input(:,i),V(:,i),U(:,i)); 
            l0=G_xy(input(:,i),V(:,i),U(:,i));
            
            V(:,i+1)=V(:,i)+k0*delta_t;
            U(:,i+1)=U(:,i)+l0*delta_t;

            % spiking 
            temp=V(:,i+1);
            index=find(temp>0);
            temp(temp>0)=Vr;
            V(:,i+1)=temp;
            V(index,i)=50E-3;
            
            U(index,i+1)=U(index,i+1)+b;
end

end

