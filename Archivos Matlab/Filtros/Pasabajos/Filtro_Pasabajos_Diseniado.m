function[]=Filtro_Pasabajos_Diseniado(sample_frequency)
N=[0.259 0.518 0.259];      %Numerador
D=[1.979 -0.481 -0.461];    %Denominador

% Visualizamos la respuesta en frecuencia
[h,w]=freqz(N,D);
figure(6)
hold on
plot(w*sample_frequency/pi,abs(h)/max(abs(h)))
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [veces]')
title('Filtro Pasa Bajos Diseniado')
end