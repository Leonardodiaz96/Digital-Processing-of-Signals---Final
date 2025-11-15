function[]=Notch_Frequency_Response(num,den,sample_freq)

% Visualizamos la respuesta en frecuencia
[h,freq] = freqz(num,den);
plot(freq*sample_freq/(2*pi),20*log(abs(h)));
xlabel('Frequencia [Hz]');
ylabel('Amplitud [dB]');
title('Filtro Notch - Respuesta en frecuencia [dB]');

end