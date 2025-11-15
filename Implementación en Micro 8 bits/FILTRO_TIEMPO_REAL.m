%%
muestras=3000;
Fs=800;
s=zeros(1,muestras);

%Inicializacion de parametros para las señales ECG
ns=0:length(s)-1;      %Barrido de tiempo igual al numero de datos adquiridos
ns=ns*1/Fs;   %Normalizacion por T=1/Fs



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
BLOQUE=1;

%%
%Filtro Pasa-bajos
Fc=120;                               %Frecuencia del filtro Pasa-bajos
N=3;                                  %Orden del filtro Pasa-bajos
w_lp=Fc/(Fs/2);            
[num_lp,den_lp] = butter(N,w_lp);     %Coeficientes de la Funcion Transferencia

%Filtro Notch
CT_notch_freq=50;                       %Frecuencia del Filtro Notch
w_n=CT_notch_freq/(Fs/2); %Frecuencia de rechaza banda
Q=35;                                   %Factor de calidad
bw=w_n/Q;                              
[num_n,den_n] = iirnotch(w_n,bw);       %Coeficientes

%Conexion en cascada
FTlp = tf(num_lp,den_lp);   %Generamos la funcion transferencia del filtro pasa bajo
FTn = tf(num_n,den_n);      %Generamos la funcion transferencia del filtro notch

FTcascada=FTlp*FTn;         %Funcion de transferencia del sistema total
[num,den] = tfdata(FTcascada,'v');

%NOTA: La funcion tfdata genera los vectores que contienen los coeficientes
%del numerador y denominador de la funcion transferencia

%Generamos los registros
buffer_LIFO1=zeros(1,L);    %buffer LIFO 1
buffer_LIFO2=zeros(1,L);    %buffer LIFO 2
buffer_FIFO=zeros(1,2*L);   %buffer FIFO

signal_salida=zeros(1,length(s));
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


%%

figure('Name','FILTRADO EN TIEMPO REAL','NumberTitle','off')
set(gcf,'Color',[.53 .53 .53],'MenuBar','None');
% set(gca,'Color','k');
title('Senial ECG')
xlabel('tiempo [seg]')
ylabel('Muestras [mV]')

delete(instrfind({'Port'},{'COM4'}));
puerto=serial('COM4');
puerto.BaudRate=9600;
fopen(puerto);

contador=1;



voltaje=zeros(1,muestras);




    
    while contador<=muestras

        
    t=linspace(0,contador,contador);

    valorADC=fscanf(puerto,'%d');
    voltaje(contador)=valorADC(1)*5/1024;
    
    
    
    [salida_LIFO1,buffer_LIFO1,j,flag,BLOQUE]=LIFO(contador,j,flag,buffer_LIFO1,voltaje,BLOQUE);
    if(flag==1)
        [salida_H1,z1]=Filtrar(num,den,0,z1);
        [salida_H2,z2]=Filtrar(num,den,salida_LIFO1,z2);
        [salida_FIFO,buffer_FIFO]=FIFO(L,contador,buffer_FIFO,salida_H2);
        SUMA=salida_FIFO+salida_H1;
    else
        [salida_H1,z1]=Filtrar(num,den,salida_LIFO1,z1);
        [salida_H2,z2]=Filtrar(num,den,0,z2);
        [salida_FIFO,buffer_FIFO]=FIFO(L,contador,buffer_FIFO,salida_H1);
        SUMA=salida_FIFO+salida_H2;
    end
    [salida_LIFO2,buffer_LIFO2,j2,flag2]=LIFO2(j2,flag2,buffer_LIFO2,SUMA);
    [salida_H3,z3]=Filtrar(num,den,salida_LIFO2,z3);
    signal_salida(contador)=salida_H3;
 
    


   
   plot(t,signal_salida(1:contador),'r','Linewidth',2);
    
     if contador<=200
        axis([0,t(contador),0,3.5])
    else
        axis([t(contador-200),t(contador),0,3.5])
     end
    
     
    drawnow limitrate
    contador=contador+1;
    
    
    
    
    end

    
    %%
fclose(puerto);
delete(puerto);
clear all;
clc;


