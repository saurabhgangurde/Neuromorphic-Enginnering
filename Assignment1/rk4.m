function [V,U] = rk4(delta_t,T,input,neuron_type)

    [C,kz,Er,Et,a,b,c,d,v_peak]=neuron_data(neuron_type);
    polynom = [kz/c,-1-((Er+Et)*kz/b),Er+Er*Et*kz/b];
    root_temp=roots(polynom);
    
    x = 0:delta_t:T;                                         % Calculates upto y(3)
    V = zeros(size(input,1),size(x,2)); 
    U = zeros(size(input,1),size(x,2)); 
    
    V(:,1) = root_temp(2);                                          % initial condition
    U(:,1) = (root_temp(2)-Er)*b;                                          % initial condition
    
    F_xy = @(I,v,u) (1/C)*(kz*(v.^2-(Et+Er)*v+Et*Er)-u+I);% change the function as you desire
    G_xy = @(I,v,u) a*(b*(v-Er)-u);
    
    %% loop for V calc
for i=1:size(x,2)-1 
            k0=F_xy(input(:,i),V(:,i),U(:,i)); 
            l0=G_xy(input(:,i),V(:,i),U(:,i));
            k1=F_xy(input(:,i),V(:,i)+0.5*k0*delta_t,U(:,i)+0.5*l0*delta_t);
            l1=G_xy(input(:,i),V(:,i)+0.5*k0*delta_t,U(:,i)+0.5*l0*delta_t);
            k2=F_xy(input(:,i),V(:,i)+0.5*k1*delta_t,U(:,i)+0.5*l1*delta_t);
            l2=G_xy(input(:,i),V(:,i)+0.5*k1*delta_t,U(:,i)+0.5*l1*delta_t);
            k3=F_xy(input(:,i),V(:,i)+k2*delta_t,U(:,i)+l2*delta_t);
            l3=G_xy(input(:,i),V(:,i)+k2*delta_t,U(:,i)+l2*delta_t);
            
            V(:,i+1)=V(:,i)+(1/6)*(k0+2*k1+2*k2+k3)*delta_t;
            U(:,i+1)=U(:,i)+(1/6)*(l0+2*l1+2*l2+l3)*delta_t;

            % spiking 
            temp=V(:,i+1);
            index=find(temp>20*10^-3);
            temp(temp>20*10^-3)=c;
            V(:,i+1)=temp;
            V(index,i)=v_peak;
            
            U(index,i+1)=U(index,i+1)+d;
end
end