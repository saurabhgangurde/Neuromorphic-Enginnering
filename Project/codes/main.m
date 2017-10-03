
Nin=32*32;
Nout=4;
Ntotal=Nin+Nout;

% defining Weights matrix
ns=1E-9;
us=1E-6;
T=0.6*us;
delta_t=1*ns;
t=0:delta_t:T;
Vth=1;
Cm=1E-12;
R=1E6;

spikes=zeros(Ntotal,size(t,2));

Weights=500E3*rand(Ntotal,4);    % 500K = max Resistance state of synapse
Weights(Nin+1:end,:)=500;
Weights_init=Weights;
SET_threshold=normrnd(1.95,0.15,[Ntotal,4]);
RESET_threshold=-1.7;

load('./database/database.mat')
weak_spike=0.8*ones(1,500);
strong_spike=[-0.8*ones(1,10) 1.9*ones*ones(1,10)];
for iter=1:200
    iter
    
    image=database{1,iter};
    input=reshape(image,[32*32,1]);
    spiking_neurons=find(input>100);
    spikes(spiking_neurons,1:500)=ones(size(spiking_neurons))*weak_spike;
    Voltages=zeros(Nout,size(t,2));
    Isyn=zeros(4,size(t,2));
    
    % simulation for time T
    for time_t=1:size(t,2)-1
        for output=1:4
            
            Isyn(output,time_t)=sum((spikes(1:Nin,time_t)-spikes(Nin+output,time_t))./Weights(1:Nin,output))...
                               +sum((spikes(Nin+output,time_t)-spikes(Nin+1:end,time_t))./Weights(Nin+1:end,output));
            for input=1:Nin
                %[input spikes(input,time_t)-spikes(Nin+output,time_t)]
                if spikes(input,time_t)-spikes(Nin+output,time_t)>SET_threshold(input,output)  % SET condition
                    %fprintf('here\n');
                    Weights(input,output)=500;
                else if spikes(input,time_t)-spikes(Nin+output,time_t)<RESET_threshold         % RESET condition
                     %fprintf('here RESET\n');
                    SET_threshold(input,output)=normrnd(1.95,0.3);
                    Weights(input,output)=Weights(input,output)+500;
                            if Weights(input,output)>500E3
                                Weights(input,output)=500E3;
                            end
                    end
                end
            end
            %Isyn(output,time_t)
            Voltages(output,time_t+1)=1/Cm*(Isyn(output,time_t)-Voltages(output,time_t)/R)*delta_t+Voltages(output,time_t);
            
            if Voltages(output,time_t+1) >1
                %[output, Voltages(output,time_t+1),Voltages(output,time_t), time_t]
                Voltages(output,time_t+1)=0;
                if spikes(Nin+output,time_t+1)==0
                    spikes(Nin+output,time_t+1:time_t+20)=strong_spike;
                end
                %output
            end           
            
        end
    end
end
        
          
figure()
imshow([uint8(reshape(Weights_init(1:32*32,1),[32,32])/500E3*255) uint8(reshape(Weights(1:32*32,1),[32,32])/500E3*255)])
figure()
imshow([uint8(reshape(Weights_init(1:32*32,2),[32,32])/500E3*255) uint8(reshape(Weights(1:32*32,2),[32,32])/500E3*255)])
figure()
imshow([uint8(reshape(Weights_init(1:32*32,3),[32,32])/500E3*255) uint8(reshape(Weights(1:32*32,3),[32,32])/500E3*255)])
figure()
imshow([uint8(reshape(Weights_init(1:32*32,4),[32,32])/500E3*255) uint8(reshape(Weights(1:32*32,4),[32,32])/500E3*255)])