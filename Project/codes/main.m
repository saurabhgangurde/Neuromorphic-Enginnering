
rng(100);
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
Cm=1E-10;
R=1E6;



Weights=500E3*rand(Ntotal,4);    % 500K = max Resistance state of synapse
Weights(Nin+1:end,:)=0.001;
Weights_init=Weights;
%SET_threshold=normrnd(1.95,0.15,[Ntotal,4]);
SET_threshold=1.5+rand([Ntotal,4]);
RESET_threshold=-1.7;

load('./database/database.mat')
weak_spike=0.8*ones(1,500);
strong_spike=[-0.8*ones(1,10) 1.9*ones*ones(1,10)];

for epoch=1:1
    epoch
    for iter=1:200
        iter

        image=database{1,iter};
        input=reshape(image,[32*32,1]);
        spikes=zeros(Ntotal,size(t,2));
        spiking_neurons=find(input>100);
        spikes(spiking_neurons,1:500)=ones(size(spiking_neurons))*weak_spike;
        Voltages=zeros(Nout,size(t,2));
        Isyn=zeros(4,size(t,2));
        last_spike=zeros(Nout)-100;
        winning_spike=-100;
        winning_neuron=0;
        b=0;

        % simulation for time T
        for time_t=1:size(t,2)-1
            %time_t
            for output=1:4
                Isyn(output,time_t)=sum((spikes(1:Nin,time_t)-spikes(Nin+output,time_t))./Weights(1:Nin,output));...
                                    %-sum((spikes(Nin+1:end,time_t)-spikes(Nin+output,time_t))./500);


                if winning_spike+20<time_t 
                    Voltages(output,time_t+1)=1/Cm*(Isyn(output,time_t)-Voltages(output,time_t)/R)*delta_t+Voltages(output,time_t);

                else if winning_neuron~=output && winning_neuron~=0
                        Voltages(output,time_t+1)=0;
                    end
                end
                %[Voltages(output,time_t+1),1/Cm*(Isyn(output,time_t)-Voltages(output,time_t)/R)*delta_t,output,time_t]

                if (Voltages(output,time_t+1)>1) && winning_spike+20<time_t

                    last_spike(output)=time_t;
                    winning_spike=time_t;
                    winning_neuron=output;
                    Voltages(1:end,time_t)=0;
                    spikes(Nin+output,time_t+1:time_t+20)=strong_spike;
                    b=1;
                    %[output,time_t]
                end

                for input=1:Nin

                    if spikes(input,time_t)-spikes(Nin+output,time_t)>SET_threshold(input,output)  % SET condition
                        %fprintf('here SET\n');
                        Weights(input,output)=5000;
                    else if spikes(input,time_t)-spikes(Nin+output,time_t)<RESET_threshold         % RESET condition
                         %fprintf('here RESET\n');
                         %SET_threshold(input,output)=normrnd(1.95,0.3);
                        Weights(input,output)=Weights(input,output)+500;
                                if Weights(input,output)>500E3
                                    Weights(input,output)=500E3;
                                end
                        end
                    end
                end
                
            end

        end

    end
end
        
max_resistance=500E3;          
figure(1)
imshow([uint8(reshape(Weights_init(1:32*32,1),[32,32])/max_resistance*255) uint8(reshape(Weights(1:32*32,1),[32,32])/max_resistance*255)])
figure(2)
imshow([uint8(reshape(Weights_init(1:32*32,2),[32,32])/max_resistance*255) uint8(reshape(Weights(1:32*32,2),[32,32])/max_resistance*255)])
figure(3)
imshow([uint8(reshape(Weights_init(1:32*32,3),[32,32])/max_resistance*255) uint8(reshape(Weights(1:32*32,3),[32,32])/max_resistance*255)])
figure(4)
imshow([uint8(reshape(Weights_init(1:32*32,4),[32,32])/max_resistance*255) uint8(reshape(Weights(1:32*32,4),[32,32])/max_resistance*255)])