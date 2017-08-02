function [C,kz,Er,Et,a,b,c,d,v_peak]=neuron_data(neuron_type)
    if neuron_type==1
        C=100 *10^-12;
        kz=0.7*10^-6;
        Er=-60*10^-3;
        Et=-40*10^-3;
        a=30;
        b=-2*10^-9;
        c=-50*10^-3;
        d=100*10^-12;
        v_peak=35*10^-3;
    
    elseif neuron_type==2
        C=150 *10^-12;
        kz=1.2*10^-6;
        Er=-75*10^-3;
        Et=-45*10^-3;
        a=10;
        b=5*10^-9;
        c=-56*10^-3;
        d=130*10^-12;
        v_peak=50*10^-3;
    else
        C=50 *10^-12;
        kz=1.5*10^-6;
        Er=-60*10^-3;
        Et=-40*10^-3;
        a=30;
        b=1*10^-9;
        c=-40*10^-3;
        d=150*10^-12;
        v_peak=25*10^-3;
    
    end
end