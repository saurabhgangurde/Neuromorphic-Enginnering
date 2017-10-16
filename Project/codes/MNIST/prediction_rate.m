Nin=28*28;
Nout=10;
Ntotal=Nin+Nout;

ns=1E-9;
us=1E-6;
T=0.6*us;
delta_t=1*ns;
t=0:delta_t:T;
Vth=1;
Cm=1E-10;
R=1E6;


test_set=data(1:500,:);
labels=data(1:500,1);
load('./Weights.mat');
correct_prediction=0;
total_prediction=size(test_set,1);

weak_spike=0.8*ones(1,500);
strong_spike=[-0.8*ones(1,10) 1.9*ones*ones(1,10)];
for iter=1:total_prediction
        iter

        
        input=transpose(reshape(test_set(iter,2:785),[28,28]));
        spikes=zeros(Ntotal,size(t,2));
        spiking_neurons=find(input>100);
        spikes(spiking_neurons,1:500)=ones(size(spiking_neurons))*weak_spike;
        Voltages=zeros(Nout,size(t,2));
        Isyn=zeros(4,size(t,2));
        last_spike=zeros(Nout)-100;
        winning_spike=-100;
        winning_neuron=0;
        total_spikes=zeros(Nout,1);

        % simulation for time T
        for time_t=1:size(t,2)-1
            %time_t
            for output=1:4
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
                    total_spikes(output)=total_spikes(output)+1;
                    Voltages(1:end,time_t)=0;
                    spikes(Nin+output,time_t+1:time_t+20)=strong_spike;
        
                    
                end
                
            end
            
            

        end
        [M,predicted_neuron]=max(total_spikes);
        if output_map(predicted_neuron)==labels(iter);
            correct_prediction=correct_prediction+1;
        end
end

accuracy=correct_prediction/total_prediction*100