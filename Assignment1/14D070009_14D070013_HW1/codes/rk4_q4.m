function [volt,m1,n1,h1,x] = rk4_q4(T,input)
    
    [C,VNa,VK,VL,gNa,gK,gL]=neuron_data_q4();

am = @(V) -0.1 * (35+V) ./ (exp(-0.1*(35+V)) - 1);
bm = @(V) 4 * exp(-(60+V)/18);

ah = @(V) 0.07 * exp(-(60+V)/20);
bh = @(V) 1 ./ (exp(-(30+V)/10) + 1);

an = @(V) 0.01 * (-(50+V)) ./ (exp(-0.1*(50+V)) - 1);
bn = @(V) 0.125 * exp(-(60+V)/80);


f = @(t,y) [ (-gK*y(3).^4.*(y(1) - VK) - gNa*y(2).^3.*y(4).*(y(1)-VNa)-gL.*(y(1)-VL) + input(t))/C; ...
               am(y(1)).*(1-y(2))-bm(y(1)).*y(2); ...
               an(y(1)).*(1-y(3))-bn(y(1)).*y(3); ...
               ah(y(1)).*(1-y(4))-bh(y(1)).*y(4) ];
         
[T, Y] = ode45(f, [0 T], [-30 0 0.4 0.4]);

volt=Y(:,1);
m1=Y(:,2);
n1=Y(:,3);
h1=Y(:,4);
x=T;

end