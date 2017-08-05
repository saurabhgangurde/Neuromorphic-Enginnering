function [y,z] = rk4_q3(delta_t,T,input,neuron_type)
    
    x = 0:delta_t:T;                                          % Calculates upto y(3)
    y = zeros(size(input,1),size(x,2)); 
    z = zeros(size(input,1),size(x,2)); 
    
    %% loop for V calc
    for j=1:(size(input,1))
        [C,gL,EL,vT,del_T,a,tau_w,b,Vr]=nueron_data_q3(neuron_type(j));

        %%% calculating steady state initial value for 3a
        syms V U 
        [sol_V,sol_U] = vpasolve([-gL*(V-EL)+(gL*del_T*exp((V-vT)/del_T)) == U , a*(V-EL) == U], [V,U] );

        V(j,1) = sol_V;                                          % initial condition
        U(j,1) = sol_U;                                          % initial condition

        F_xy = @(I,v,u) (1/C)*(-gL*(v-EL)+gL*del_T*exp((v-vT)/del_T)-u+I);% change the function as you desire
        G_xy = @(I,v,u) (1/tau_w)*(a*(v-EL)-u);

        for i=1:size(x,2)-1 
%             k0=F_xy(input(j,i),y(j,i),z(j,i)); 
%             l0=G_xy(input(j,i),y(j,i),z(j,i));
%             k1=F_xy(input(j,i),y(j,i)+0.5*k0*delta_t,z(j,i)+0.5*l0*delta_t);
%             l1=G_xy(input(j,i),y(j,i)+0.5*k0*delta_t,z(j,i)+0.5*l0*delta_t);
%             k2=F_xy(input(j,i),y(j,i)+0.5*k1*delta_t,z(j,i)+0.5*l1*delta_t);
%             l2=G_xy(input(j,i),y(j,i)+0.5*k1*delta_t,z(j,i)+0.5*l1*delta_t);
%             k3=F_xy(input(j,i),y(j,i)+k2*delta_t,z(j,i)+l2*delta_t);
%             l3=G_xy(input(j,i),y(j,i)+k2*delta_t,z(j,i)+l2*delta_t);
            
            y(j,i+1)=y(j,i)+(1/6)*(k0+2*k1+2*k2+k3)*delta_t;
            z(j,i+1)=z(j,i)+(1/6)*(l0+2*l1+2*l2+l3)*delta_t;

            if y(j,i+1)>0
                        
                        y(j,i+1)=Vr;
                        z(j,i+1)=z(j,i)+b;
            end
        end
    end
end