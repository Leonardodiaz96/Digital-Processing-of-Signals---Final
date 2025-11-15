%LEER DATOS DESDE ARDUINO
delete(instrfind({'Port'},{'COM3'}));
sig=serial('COM3','BaudRate',9600,'Terminator','CR/LF');
warning('off','MATLAB:serial:fscanf:UnsuccesfulRead');
fopen(sig);

%% parámetros de medidas
tmax = 60; % tiempo de captura en s
rate = 800; % resultado experimental (comprobar)

% v1 = zeros(1,5000);
% a=zeros(1,5000);

% preparar la figura
f = figure('Name','Captura');
a = axes('XLim',[0 tmax],'YLim',[0 5]);
l1 = line(nan,nan,'Color','r','LineWidth',2);


xlabel('Tiempo (s)')
ylabel('Voltaje (V)')
title('Captura de voltaje en tiempo real con Arduino')
grid on
hold on


% inicializar
v1 = zeros(1,tmax*rate);

i = 1;
t = 0;

% ejecutar bucle cronometrado
tic
while t<tmax
    t = toc;
    % leer del puerto serie
    a = fscanf(sig,'%d')';
    v1(i)=a(1)*5/1023;
   
    % dibujar en la figura
    x = linspace(0,i/rate,i);
    set(l1,'YData',v1(1:i),'XData',x);
    
    drawnow
    % seguir
    i = i+1;
   
end
% resultado del cronometro
clc;
fprintf('%g s de captura a %g cap/s \n',t,i/t);

%%
tiempo=60;
intervalo=0.5;
i=1;
tic
t=zeros(1,5000);
x=zeros(1,5000);

while toc<tiempo
    t(i)=toc;
    x=fscanf(sig,'%d')';
    plot(t(:),x(:),'r'),xlabel('seg'),ylabel('V');
    drawnow
    i=i+1;
    pause(intervalo);
end
  
%%


delete(instrfind({'Port'},{'COM3'}));
puerto=serial('COM3');
puerto.BaudRate=9600;
fopen(puerto);

contador=1;
muestras=3000;
Fs=800;


voltaje=zeros(1,muestras);


ns=0:muestras-1;      %Barrido de tiempo igual al numero de datos adquiridos
ns=ns*1/Fs;   %Normalizacion por T=1/Fs


figure(3)
title('KK DE MONO');
% hold on
while contador<=muestras
%     ylim=([0 3.5]);
%     xlim=([0 muestras]);
  t=linspace(0,contador,contador);

    valorADC=fscanf(puerto,'%d');
    voltaje(contador)=valorADC(1)*5/1024;
    
   
    
    plot(t,voltaje(1:contador),'r','Linewidth',2);
    
     if contador<=200
        axis([0,t(contador),0,3.5])
    else
        axis([t(contador-200),t(contador),0,3.5])
     end
    
     
    drawnow limitrate
    contador=contador+1;
end
%%
i=1;
sen=zeros(1,131);
% while i<39
a = fscanf(sig,'%d')';
sen=a;
i=i+1;
% pause(1);
% end
%%
fclose(sig);
delete(sig);
clear all;
clc;

%%
fclose(puerto);
delete(puerto);
clear all;
clc;

%%
figure('Name','FILTRADO EN TIEMPO REAL','NumberTitle','off')
set(gcf,'Color',[.53 .53 .53],'MenuBar','None');
set(gca,'Color','k');
title('Senial ECG')
xlabel('tiempo [seg]')
ylabel('Muestras [mV]')

