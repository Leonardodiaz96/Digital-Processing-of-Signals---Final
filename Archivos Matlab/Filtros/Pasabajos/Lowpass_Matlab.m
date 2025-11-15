function[]=FIR_Lowpass_Matlab(order,Fc_analog,sample_frequency)
% Calculo de la Frecuencia de Muestreo
Ws=2*pi*sample_frequency;
% Calculo de la Frecuencia de Corte Digital
Wc=2*pi*Fc_analog;

% Genera ventana Hamming (ancho filtro FIR)
Wrect=ones(order+1,1);
hpbmatlab = fir1(order,Wc/(Ws/2),Wrect); %Funcion de Matlab

% Visualizamos la respuesta en frecuencia
[hpbmatlab,w1]=freqz(hpbmatlab,1);
f=w1/2*pi;
figure(7)
hold on
plot(f*sample_frequency/max(f),abs(hpbmatlab),'r')
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [veces]')
title('Filtro Pasa Bajos FIR - Matlab')
end