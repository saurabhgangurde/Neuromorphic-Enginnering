function [C,gL,EL,vT,del_T,a,tau_w,b,Vr]=neuron_data_q3(neuron_type)
    if neuron_type==1
        C=200 *10^-12;
        gL=10*10^-9;
        EL= -70*10^-3;
        vT=-50*10^-3;
        del_T=2*10^-3;
        a = 2*10^-9;
        tau_w=30*10^-3;
        b=0;
        Vr=-58*10^-3;
    
    elseif neuron_type==2
        C=130 *10^-12;
        gL=18*10^-9;
        EL= -58*10^-3;
        vT=-50*10^-3;
        del_T=2*10^-3;
        a = 4*10^-9;
        tau_w=150*10^-3;
        b=120*10^-12;
        Vr=-50*10^-3;
    
    else
        C=200 *10^-12;
        gL=10*10^-9;
        EL= -58*10^-3;
        vT=-50*10^-3;
        del_T=2*10^-3;
        a = 2*10^-9;
        tau_w=120*10^-3;
        b=100*10^-12;
        Vr=-46*10^-3;
    end
end