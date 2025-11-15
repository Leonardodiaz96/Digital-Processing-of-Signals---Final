function[num,den]=Lowpass_Design(order,Fc_analog,sample_freq)

% Calculo de la Frecuencia de corte digital
wn=Fc_analog/(sample_freq/2);

[num,den] = butter(order,wn);

end