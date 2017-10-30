%% Predefined weights

total_weights=0.01*ones(10,784); %% from 0-9 
occurence = zeros(10,1);
final_weights=[];
for j=0:9
    for i =1:10000
        if data(i,1)==j
            occurence(j+1,1) = occurence(j+1,1)+1; 
            total_weights(j+1,:) = total_weights(j+1,:) + data(i,2:785);
        end
    end
    total_weights(j+1,:) = total_weights(j+1,:)/255/occurence(j+1,1);
    total_weights(j+1,:) = reshape(transpose(reshape(total_weights(j+1,:),[28,28])),[1,784]);

end
total_weights = transpose(total_weights);


rng(100);
Nin=28*28;
Nout=10;
Ntotal=Nin+Nout;

% defining Weights matrix
ns=1E-9;
us=1E-6;
T=1.2*us;
delta_t=1*ns;
t=0:delta_t:T;
Vth=1;
Cm=1E-8;
R=1E6;

Weights = zeros(Ntotal,10);
Weights(1:Nin,:)=500E3*total_weights;    % 500K = max Resistance state of synapse
Weights(Nin+1:end,:)=0.001;
SET_threshold=1.5+rand([Ntotal,10]);
RESET_threshold=-1.7;

%data=csvread('./mnist_train.csv');
label=data(:,1);
neuron_labels=cell(10,1);
weak_spike=0.8*ones(1,500);
strong_spike=[-0.8*ones(1,10) 1.9*ones*ones(1,10)];
detected =[];
original =[];

for epoch=1:1
    for iter=10001:10200     %% 200 initial imagaes are being analyzed
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

        for time_t=1:size(t,2)-1
            for output=1:10
                Isyn(output,time_t) = sum((spikes(1:Nin,time_t)-spikes(Nin+output,time_t))./Weights(1:Nin,output))...
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
                end
            end
        end
        detected = [detected winning_neuron-1];
        original = [original data(iter,1)];

    end

end 
final_out = vertcat(detected, original);


% accuracy calc
accuracy = 0;
for i = 1:size(final_out,2)
    if final_out(1,i) == final_out(2,i)
        accuracy = accuracy+1;
    end
end
accuracy = accuracy*100/size(final_out,2)
