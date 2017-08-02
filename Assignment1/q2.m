N=10;
T=0.500;
delta_t= 0.1 * 10^-3;
M=T/delta_t;
input=zeros(N,M);

for i=1:N
    input(i,:)=400*10^-12;
end
%%% specify neuron type as 1 2 3
%% Q 1b
x = 0:delta_t:T;
[y,z] = rk4(delta_t,T,input,1);

%{
%% Q 1c
figure()
plot(x,y(2,:),x,y(4,:),x,y(6,:),x,y(8,:));
%plot(x,y(2,:));
plot_formatting('time','cell potential');

%% Q 1d
interval=[];

for j=1:size(y,1)
    for i=2:size(y,2)
        if y(j,i)== EL
            interval=[interval i*delta_t]
            break
        end
    end
end
figure()
plot(interval,'linewidth',3.0);
plot_formatting('neuron number','spiking time');
%}            