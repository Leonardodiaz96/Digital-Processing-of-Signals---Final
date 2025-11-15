function[]=Lowpass_Frequency_Response(num,den,sample_freq)

[h,w]=freqz(num,den);

% Visualizamos la respuesta en frecuencia
figure(3);
hold on
plot(w*sample_freq/(2*pi),abs(h));
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [veces]')
title('Filtro Pasa Bajos - Respuesta en frecuencia');

figure(4)
hold on
f=w/2*pi;
plot(f*sample_freq/max(f),20*log10(abs(h)/abs(h(1))))
xlabel('Frequencia [Hz]');
ylabel('Amplitud [dB]');
title('Filtro Pasa Bajos - Respuesta en frecuencia [dB]')

end