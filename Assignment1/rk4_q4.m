function [volt,m1,n1,h1] = rk4_q4(delta_t,T,input)
    
    [C,ENa,EK,EL,gNa,gK,gL]=neuron_data_q4();
    
    x = 0:delta_t:T;                                          % Calculates upto y(3)
    volt = zeros(size(input,1),size(x,2)); 
    m1 = zeros(size(input,1),size(x,2)); 
    n1 = zeros(size(input,1),size(x,2)); 
    h1 = zeros(size(input,1),size(x,2)); 
    
    syms v m n h 
    
    [v_init,m_init,n_init,h_init] = vpasolve([(-gNa*m^3*h*(v-ENa)-gK*n^4*(v-EK)-gL*(v-EL))==0 ...
    , (0.01*(v*1000+55))/(1-exp(-(v*1000+55)/10))*(1-n)-n*0.125*exp(-(v*1000+65)/80)==0 ...
    , (0.1*(v*1000+40))/(1-exp(-(v*1000+40)/10))*(1-m)-m*4*exp(-0.0556*(v*1000+65))==0 ...
    , (0.07*exp(-0.005*(v*1000+65)))*(1-h)-h*(1/1+(exp(-0.1*(v*1000+35))))==0], ...
   [v,m,n,h] );

    volt(:,1) =v_init;
    m1(:,1)=m_init;
    n1(:,1)=n_init;
    h1(:,1)=h_init;
    
    F_xy = @(I,v,m,n,h) (1/C)*(-gNa*m^3*h*(v-ENa)-gK*n^4*(v-EK)-gL*(v-EL)+I);
    G_xy = @(I,v,m,n,h) ((0.01*(v*1000+55))/(1-exp(-(v*1000+55)/10)))*(1-n)-n*(0.125*exp(-(v*1000+65)/80))    ;
    H_xy = @(I,v,m,n,h) ((0.1*(v*1000+40))/(1-exp(-(v*1000+40)/10)))*(1-m)-m*(4*exp(-0.0556*(v*1000+65)));
    I_xy = @(I,v,m,n,h) (0.07*exp(-0.05*(v*1000+65)))*(1-h)-h*(1/(1+(exp(-0.1*(v*1000+35)))));
    
    %% loop for V calc
for i=1:size(x,2)-1 
          
            f0=F_xy(input(:,i),volt(:,i),m1(:,i),n1(:,i),h1(:,i)); 
            g0=G_xy(input(:,i),volt(:,i),m1(:,i),n1(:,i),h1(:,i));
            h0=H_xy(input(:,i),volt(:,i),m1(:,i),n1(:,i),h1(:,i));
            i0=I_xy(input(:,i),volt(:,i),m1(:,i),n1(:,i),h1(:,i));
            
%             f1 =F_xy(input(j,i),volt(j,i)+delta_t*f0,m1(j,i)+delta_t*f0,n1(j,i)+delta_t*f0,h1(j,i)+delta_t*f0);
%             g1 =G_xy(input(j,i),volt(j,i)+delta_t*g0,m1(j,i)+delta_t*g0,n1(j,i)+delta_t*g0,h1(j,i)+delta_t*g0);
%             h_1=H_xy(input(j,i),volt(j,i)+delta_t*h0,m1(j,i)+delta_t*h0,n1(j,i)+delta_t*h0,h1(j,i)+delta_t*h0);
%             i1 =I_xy(input(j,i),volt(j,i)+delta_t*i0,m1(j,i)+delta_t*i0,n1(j,i)+delta_t*i0,h1(j,i)+delta_t*i0);
%             
            volt(:,i+1) = volt(:,i)   + f0*delta_t;  
            m1(:,i+1)   = m1(:,i)     + g0*delta_t;
            n1(:,i+1)   = n1(:,i)     + h0*delta_t;
            h1(:,i+1)   = h1(:,i)     + i0*delta_t;
            
end

end