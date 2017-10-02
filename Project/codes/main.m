
Nin=32*32;
Nout=4;
Ntotal=Nin+Nout;

% defining Weights matrix
ns=1E-9;
us=1E-6;
T=1*us;
delta_t=1*ns;
t=0:delta_t:T;
Vth=1;
Cm=1E-12;
R=1E6;

spikes=zeros(Ntotal,size(t,2));
Voltages=zeros(Nout,size(t,2));
Isyn=zeros(4,size(t,2));
Weights=500E3*rand(Ntotal,4);    % 500K = max Resistance state of synapse
SET_threshold=1.95*ones(Ntotal,4)+sqrt(0.15)*rand(Ntotal,4);
RESET_threshold=-1.5;

load('./database/database.mat')
weak_spike=0.8*ones(1,500);
strong_spike=[-0.8*ones(1,10) 1.9*ones*ones(1,10)];
for iter=1:20
    iter
    
    image=database{1,1};
    input=reshape(image,[32*32,1]);
    spiking_neurons=find(input>100);
    spikes(spiking_neurons,1:500)=ones(size(spiking_neurons))*weak_spike;
    
    % simulation for time T
    for time_t=1:size(t,2)-1
        for output=1:4
            Isyn(output,time_t)=sum((spikes(1:Nin,time_t)-spikes(Nin+output,time_t))./Weights(1:Nin,output))...
                               +sum((spikes(Nin+output,time_t)-spikes(Nin+1:end,time_t))./Weights(Nin+1:end,output));
            for input=1:Nin
                
                if spikes(input,time_t)-spikes(output,time_t)>SET_threshold(input,output)  % SET condition
                    Weights(input,output)=500;
                else if spikes(input,time_t)-spikes(output,time_t)<RESET_threshold         % RESET condition
                    SET_threshold(input,output)=1.95+sqrt(0.3)*rand;
                        if Weights(input,output)>500
                            Weights(input,output)=Weights(input,output)+500;
                            if Weights(input,output)>500E3
                                Weights(input,output)=500E3;
                            end
                        end
                    end
                end
            end
            Voltages(output,time_t+1)=1/Cm*(Isyn(output,time_t)-Voltages(output,time_t)/R)*delta_t+Voltages(output,time_t);
            
            if Voltages(output,time_t+1) >1
                [output, Voltages(output,time_t+1),Voltages(output,time_t)]
                Voltages(output,time_t+1)=0;
                if spikes(Nin+output,time_t+1)==0
                    spikes(Nin+output,time_t+1:time_t+20)=strong_spike;
                end
                %output
            end           
            
        end
    end
end
        
          
    