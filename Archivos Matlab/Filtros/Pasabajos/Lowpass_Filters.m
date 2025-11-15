function[]=FIR_Lowpass_Filters(order,Fc_analog,sample_frequency)
wc=(2*pi*Fc_analog)./sample_frequency; % Frecuencia de corte digital

% Funcion de sistema h(n) para una respuesta FIR
n=-(order-1)/2:(order-1)/2;
hpb=(sin(wc*n))./(pi*n);

% Termino central del Filtro FIR Pasa-bajos
hpb((order+1)/2)=wc/pi;

% Visualizamos la respuesta en frecuencia
[hfpb,w]=freqz(hpb,1); % En este caso, filtro FIR con numerador b=1
figure(5)
hold on
f=w/2*pi;
plot(f*sample_frequency/max(f),abs(hfpb)/abs(hfpb(1)))
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [veces]')
title('Filtro Pasa Bajos - Ventana Rectangular')
end