function [y,z] = rk4(delta_t,T,input,neuron_type)

    [C,kz,Er,Et,a,b,c,d,v_peak]=neuron_data(neuron_type);
    polynom = [kz/c,-1-((Er+Et)*kz/b),Er+Er*Et*kz/b];
    root_temp=roots(polynom)
    
    x = 0:delta_t:T;                                         % Calculates upto y(3)
    y = zeros(size(input,1),size(x,2)); 
    z = zeros(size(input,1),size(x,2)); 
    
    y(:,1) = root_temp(2);                                          % initial condition
    z(:,1) = (root_temp(2)-Er)*b;                                          % initial condition
    
    F_xy = @(t,r,p) (1/C)*(kz*(r^2-(Et+Er)*r+Et*Er)-p+t);% change the function as you desire
    G_xy = @(t,r,p) a*(b*(r-Er)-p);
    
    %% loop for V calc
    for j=1:(size(input,1))
        for i=1:size(x,2)-1 
            k0=F_xy(input(1,i),y(1,i),z(1,i)); 
            l0=G_xy(input(1,i),y(1,i),z(1,i));
            k1=F_xy(input(1,i),y(1,i)+0.5*k0*delta_t,z(1,i)+0.5*l0*delta_t);
            l1=G_xy(input(1,i),y(1,i)+0.5*k0*delta_t,z(1,i)+0.5*l0*delta_t);
            k2=F_xy(input(1,i),y(1,i)+0.5*k1*delta_t,z(1,i)+0.5*l1*delta_t);
            l2=G_xy(input(1,i),y(1,i)+0.5*k1*delta_t,z(1,i)+0.5*l1*delta_t);
            k3=F_xy(input(1,i),y(1,i)+k2*delta_t,z(1,i)+l2*delta_t);
            l3=G_xy(input(1,i),y(1,i)+k2*delta_t,z(1,i)+l2*delta_t);
            
            y(1,i+1)=y(1,i)+(1/6)*(k0+2*k1+2*k2+k3)*delta_t;
            z(1,i+1)=z(1,i)+(1/6)*(l0+2*l1+2*l2+l3)*delta_t;

            if y(1,i+1)>v_peak
                        y(1,i+1)=root_temp(2);
            end
        end
    end
end