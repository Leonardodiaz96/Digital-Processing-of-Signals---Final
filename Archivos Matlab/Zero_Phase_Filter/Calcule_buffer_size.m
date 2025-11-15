function[buffer_size]=Calcule_buffer_size(size_impulse,num1,den1,num2,den2,sample_freq)

impulse=zeros(1,size_impulse);
impulse(1)=1;

y1=filter(num1,den1,impulse);
y2=filter(num2,den2,y1);

n1=0:length(y2)-1;
% Afectamos por el valor del muestreo T=1/Fs
n1=n1*1/sample_freq;
figure(12)
hold on
stem(n1,y2)
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [veces]')
title('Respuesta al impulso')

% index=1;
% 
% while(abs(y2(index))>=1/(1000000.^2) && index<=length(y2))
%     index=index+1;
% end
% 
% buffer_size=index
buffer_size=500;
end