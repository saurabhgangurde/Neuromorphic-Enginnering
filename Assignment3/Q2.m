%% Q1 Representing synaptic connectivity and axonal delays

%% Part A
ms=1E-3;
N=500;

Weight=cell(1,N);
Delay=cell(1,N);

%  creating network
fanout_matrix=zeros(50,N);
fanout_matrix(:,1:round(N*0.8))=randi([1,500],[50,round(N*0.8)]);
fanout_matrix(:,round(N*0.8)+1:end)=randi([round(N*0.8)+1,N],[50,N-round(N*0.8)]);

Fanout=num2cell(fanout_matrix,1);
Weights_matrix
%% Part B

% constants
% delta_t=0.1*ms;
% T=20*ms;
% t=linspace(0,T,T/delta_t);
% Io=1E-12;
% tau=15*ms;
% tau_s=tau/4;
% EL=-70*1E-3;
% gL=30*1E-9;
% Vt=20*1E-3;
% C=300*1E-12;
% Rp=2*ms;
% input_time=cell(1,N);
% spike_time=cell(1,N);
% Iapp=zeros(N,T/delta_t);
% %% case 1
% input_time{1}=[0];input_time{2}=[4*ms];input_time{3}=[8*ms];
% 
% % forming Iapp matrix
% for i=1:N
%     for j=1:size(input_time{i},2)
%         Iapp(i,input_time{i}(j)/delta_t+1:(input_time{i}(j)+1*ms)/delta_t)=50*1E-9;
%     end
% end
% 
% [V,t]=LIF( delta_t,T,Iapp(1:3,:),EL,gL,C,Vt);
% 
% % finding spike times
% spike_time{1}=find(V(1,:)==70E-3)*delta_t;spike_time{2}=find(V(2,:)==70E-3)*delta_t;spike_time{3}=find(V(3,:)==70E-3)*delta_t;
% 
% % finding synaptic current
% Isyn=zeros(N,T/delta_t);
% 
% Isyn_t= @(we,tk,td,t) Io*we*(exp(-(t-tk-td)/tau)+exp(-(t-tk-td)/tau_s)).*(t>tk+td);
% for i=1:N
%     fanout_nodes=Fanout{i};
%     for j=1:size(fanout_nodes,2)
%         for k=1:size(spike_time{i},2)
%             Isyn(fanout_nodes(j),:)=Isyn(fanout_nodes(j),:)+Isyn_t(Weight{i}(j),spike_time{i}(k),Delay{i}(j),t);
%         end
%     end
% end
% 
% [V_2_layer,t]=LIF( delta_t,T,Isyn(4:5,:),EL,gL,C,Vt);
% 
% figure(1)
% plot(t,Isyn)
% figure(2)
% plot(t,V,t,V_2_layer);