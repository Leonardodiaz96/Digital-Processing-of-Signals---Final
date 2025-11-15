%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   UNIVERSIDAD NACIONAL DE TUCUMAN                      %
%               FACULTAD DE CIENCIAS EXACTAS Y TECNOLOGIA                %
%                                                                        %
%   Asignatura: PROCESAMIENTO DIGITAL DE SENIALES                        %
%                                                                        %
%   Equipo de trabajo:  ANCE, GASTON ARMANDO                             %
%                       ARNEDO, EMILIANO                                 %
%                       DIAZ, LEONARDO LEANDRO                           %
%                       PEREYRA, FAUSTO HORACIO                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function[]=Zero_Phase_Filter(sample_frequency,signal)

% Limpiar la ventada de comandos
close all
clc

%%
%Inicializacion de parametros para las señales ECG
ns=0:length(signal)-1;      %Barrido de tiempo igual al numero de datos adquiridos
ns=ns*1/sample_frequency;   %Normalizacion por T=1/Fs

figure(1)
Plotear_Signal(ns,signal);   % Gráfico de la señal ECG original (informe)
%figure(2)
%Plotear_Signal_2(ns,signal); % Gráfico de la señal ECG original (presentacion)

%Inicializacion de otros parametros
size_impulse=100;   %Tamaño del vector de la senial Impulso
L=500;              %Tamaño de los buffers LIFO
j=1;
j2=1;
flag=1;
flag2=1;
tiempo=linspace(1,L,L);
tiempo2L=linspace(1,2*L,2*L);
fp=1;
fp2=1;
BLOQUE=1; %Revisar si se puede rescatar esto

%%
%Filtro Pasa-bajos
Fc=120;                               %Frecuencia del filtro Pasa-bajos
N=3;                                  %Orden del filtro Pasa-bajos
[num_lp,den_lp] = Lowpass_Design(N,Fc,sample_frequency);     %Coeficientes de la Funcion Transferencia
Lowpass_Frequency_Response(num_lp,den_lp,sample_frequency);  %Respuesta en frecuencia del Filtro Pasa-bajos

%Otros disenios del Filtro Pasabajos
Lowpass_Filters(N,Fc,sample_frequency);         %Figura (5)
Filtro_Pasabajos_Diseniado(sample_frequency);   %Figura (6)
Lowpass_Matlab(N,Fc,sample_frequency);          %Figura (7)

%Filtro Notch
CT_notch_freq=50;                       %Frecuencia del Filtro Notch
AB=12;                                  %Ancho de banda
w_n=CT_notch_freq/(sample_frequency/2); %Frecuencia de rechaza banda
Q=35;                                   %Factor de calidad
bw=w_n/Q;                              
[num_n,den_n] = iirnotch(w_n,bw);       %Coeficientes

figure(8)
Notch_Frequency_Response(num_n,den_n,sample_frequency);  %Figura (8)

% Visualizamos el plano z
figure(9);
zplane(num_n,den_n);legend('zero','plot');

%Otros disenios del Filtro Notch
[num_n2,den_n2]=Notch_Design(CT_notch_freq,sample_frequency,AB);
figure(10)
Notch_Frequency_Response(num_n2,den_n2,sample_frequency);
% Visualizamos el plano z
figure(11);
zplane(num_n2,den_n2);legend('zero','plot');

%Conexion en cascada
FTlp = tf(num_lp,den_lp);   %Generamos la funcion transferencia del filtro pasa bajo
FTn = tf(num_n,den_n);      %Generamos la funcion transferencia del filtro notch

FTcascada=FTlp*FTn;         %Funcion de transferencia del sistema total
[num,den] = tfdata(FTcascada,'v');
%freqz(num,den)             %Descomentar para ver respuesta en frecuencia

%NOTA: La funcion tfdata genera los vectores que contienen los coeficientes
%del numerador y denominador de la funcion transferencia

%Determinamos el tamanio de los buffers
[L]=Calcule_buffer_size(size_impulse,num_n,den_n,num_lp,den_lp,sample_frequency);  %Figura (12)

%Generamos los registros
buffer_LIFO1=zeros(1,L);    %buffer LIFO 1
buffer_LIFO2=zeros(1,L);    %buffer LIFO 2
buffer_FIFO=zeros(1,2*L);   %buffer FIFO

signal_salida=zeros(1,length(signal));
salida_LIFO1=0;
salida_H1=0;
salida_H2=0;
salida_FIFO=0;
salida_LIFO2=0;
SUMA=0;
salida_H3=0;

%Condiciones iniciales nulas
z1=0;
z2=0;
z3=0;

for i=1:length(signal)
    [salida_LIFO1,buffer_LIFO1,j,flag,BLOQUE]=LIFO(i,j,flag,buffer_LIFO1,signal,BLOQUE);
    if(flag==1)
        [salida_H1,z1]=Filtrar(num,den,0,z1);
        [salida_H2,z2]=Filtrar(num,den,salida_LIFO1,z2);
        [salida_FIFO,buffer_FIFO]=FIFO(L,i,buffer_FIFO,salida_H2);
        SUMA=salida_FIFO+salida_H1;
    else
        [salida_H1,z1]=Filtrar(num,den,salida_LIFO1,z1);
        [salida_H2,z2]=Filtrar(num,den,0,z2);
        [salida_FIFO,buffer_FIFO]=FIFO(L,i,buffer_FIFO,salida_H1);
        SUMA=salida_FIFO+salida_H2;
    end
    [salida_LIFO2,buffer_LIFO2,j2,flag2]=LIFO2(j2,flag2,buffer_LIFO2,SUMA);
    [salida_H3,z3]=Filtrar(num,den,salida_LIFO2,z3);
    signal_salida(i)=salida_H3;

%%
%     if i<=L
%         fp=i;
%     else
%         fp=1;
%     end
%     
%      if i<=2*L
%         fp2=i;
%     else
%         fp2=1;
%     end
%     
%     figure(BLOQUE)
%     
%     subplot(2,2,1)
%     plot(tiempo(1:fp),buffer_LIFO1(1:fp))
%     title('LIFO1')
%     axis([1 L -0.6 1.5])
%     
%     subplot(2,2,2)
%     plot(tiempo2L(1:fp2),buffer_FIFO(1:fp2))
%     title('FIFO')
%     axis([1 2*L -0.6 1.5])
%     
%     subplot(2,2,3)
%     plot(tiempo(1:fp),buffer_LIFO2(1:fp))
%     title('LIFO2')
%     axis([1 L -0.6 1.5])
%     
%     pause(0.00001)
% 
%     subplot(2,2,4)
%     plot(tiempo(1:fp),signal_salida(i-(L-1):i))
%     title('SALIDA')
%       
%   if (j>L || j<1) && BLOQUE<10
%     figure('Name',['BLOQUE ' num2str(BLOQUE)],'NumberTitle','off')
%     subplot(2,2,1)
%     plot(tiempo,buffer_LIFO1)
%     title('LIFO1')
%     axis([1 L -0.6 1.5])
%     
%     subplot(2,2,2)
%     plot(tiempo2L,buffer_FIFO)
%     title('FIFO')
%     axis([1 2*L -0.6 1.5])
%     
%     subplot(2,2,3)
%     plot(tiempo,buffer_LIFO2)
%     title('LIFO2')
%     axis([1 L -0.6 1.5])
%     
%     subplot(2,2,4)
%     plot(tiempo,signal_salida(i-(L-1):i))
%     title('SALIDA')
%     axis([1 L -0.6 1.5])
%     
%     pause(1)
%   end

%NOTA: Mediante el algoritmo comentado en la parte superior de esta nota
%se puede ir visualizando como se actualizan los buffers de una manera
%didactica.
end

figure(13)
Plotear_Senial_3(ns,signal_salida); %Gráfico de la señal ECG filtrada (informe)
%Plotear_Signal_2(ns,signal_salida); %Gráfico de la señal ECG filtrada (presentacion)

%Analisis del espectro de frecuencia

%Senial ECG Original
u_out2=fft(signal);   
f_out2=sample_frequency.*(0:(length(signal)/2)-1)./length(signal);
P_out2=2.*(abs(u_out2(1:length(signal)/2)/length(signal)));

%Senial ECG Filtrada
u_out1=fft(signal_salida);   
f_out1=sample_frequency.*(0:(length(signal)/2)-1)./length(signal);
P_out1=2.*(abs(u_out1(1:length(signal)/2)/length(signal)));

figure(14)
subplot(2,1,1);
plot(f_out2,P_out2);
hold on
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [mV]')
title('Espectro de Frecuencias - Senial ECG Original');
subplot(2,1,2);
plot(f_out1,P_out1);
hold on
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [mV]')
title('Espectro de Frecuencias - Senial ECG Filtrada');

%Comparamos los resultados obtenidos con la funcion 'filtfilt' de Matlab
signal_salida_filtfilt = filtfilt(num,den,signal);

figure(15)
subplot(2,1,1);
plot(ns,signal_salida);
hold on
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [mV]')
title('Senial ECG Filtrada');
subplot(2,1,2);
plot(ns,signal_salida_filtfilt);
hold on
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [mV]')
title('Senial ECG Filtrada - filtfilt');

u_out3=fft(signal_salida_filtfilt);   
f_out3=sample_frequency.*(0:(length(signal)/2)-1)./length(signal);
P_out3=2.*(abs(u_out3(1:length(signal)/2)/length(signal)));

figure(16)
subplot(2,1,1);
plot(f_out1,P_out1);
hold on
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [mV]')
title('Espectro de Frecuencias - Senial ECG Filtrada');
subplot(2,1,2);
plot(f_out3,P_out3);
hold on
xlabel('Frecuencia [Hz]')
ylabel('Amplitud [mV]')
title('Espectro de Frecuencias - Senial ECG Filtrada (filtfilt)');