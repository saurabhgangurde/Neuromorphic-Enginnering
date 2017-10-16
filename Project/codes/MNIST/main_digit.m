rng(100);
Nin=28*28;
Nout=10;
Ntotal=Nin+Nout;

% defining Weights matrix
ns=1E-9;
us=1E-6;
T=0.6*us;
delta_t=1*ns;
t=0:delta_t:T;
Vth=1;
Cm=1E-8;
R=1E6;

Weights=500E3*rand(Ntotal,10);    % 500K = max Resistance state of synapse
Weights(Nin+1:end,:)=0.001;
Weights_init=Weights;
%SET_threshold=normrnd(1.6,0.15,[Ntotal,10]);
SET_threshold=1.5+rand([Ntotal,10]);
%SET_threshold=zeros(Ntotal,10);
RESET_threshold=-1.7;

%data=csvread('./mnist_train.csv');
label=data(:,1);
neuron_labels=cell(10,1);
weak_spike=0.8*ones(1,500);
strong_spike=[-0.8*ones(1,10) 1.9*ones*ones(1,10)];

for epoch=1:10
    epoch
    for iter=1:2     %% 200 initial imagaes are being analyzed
        iter
        input=transpose(reshape(data(iter,2:785),[28,28]));
        spikes=zeros(Ntotal,size(t,2));
        spiking_neurons=find(input>200);
        spikes(spiking_neurons,1:500)=ones(size(spiking_neurons))*weak_spike;
        Voltages=zeros(Nout,size(t,2));
        Isyn=zeros(10,size(t,2));
        last_spike=zeros(Nout)-100;
        winning_spike=-100;
        winning_neuron=0;

        % simulation for time T
        for time_t=1:size(t,2)-1
            %time_t
            for output=1:10
                Isyn(output,time_t)=sum((spikes(1:Nin,time_t)-spikes(Nin+output,time_t))./Weights(1:Nin,output))...
                                    -sum((spikes(Nin+1:end,time_t)-spikes(Nin+output,time_t))./500);
                if winning_spike+20<time_t 
                    Voltages(output,time_t+1)=1/Cm*(Isyn(output,time_t)-Voltages(output,time_t)/R)*delta_t+Voltages(output,time_t);
                else if winning_neuron~=output && winning_neuron~=0
                        Voltages(output,time_t+1)=0;
                    end
                end
                if (Voltages(output,time_t+1)>1) && winning_spike+20<time_t
                    last_spike(output)=time_t;
                    winning_spike=time_t;
                    winning_neuron=output;
                    Voltages(1:end,time_t)=0;
                    spikes(Nin+output,time_t+1:time_t+20)=strong_spike;
                    neuron_labels{output,1}=[neuron_labels{output,1},label(iter)];
                end

                for input=1:Nin
                   if spikes(input,time_t)-spikes(Nin+output,time_t)>SET_threshold(input,output) % SET condition
                        Weights(input,output)=500;
                    else if spikes(input,time_t)-spikes(Nin+output,time_t)<RESET_threshold         % RESET condition
                         %SET_threshold(input,output)=normrnd(1.95,0.3);
                            Weights(input,output)=Weights(input,output)+5000;
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
total_weights=[];
output_map=zeros(1,10);
for i =1:10
     total_weights = vertcat(total_weights,[uint8(reshape(Weights_init(1:28*28,i),[28,28])/max_resistance*255)...
                                            uint8(reshape(Weights(1:28*28,i),[28,28])/max_resistance*255)]);
     output_map(i)=mode(neuron_labels{i,1});
end 
imshow(total_weights);


save('./Weights.mat','Weights');
