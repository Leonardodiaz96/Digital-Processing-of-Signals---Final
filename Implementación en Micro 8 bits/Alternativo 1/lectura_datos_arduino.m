%LEER DATOS DESDE ARDUINO
delete(instrfind({'Port'},{'COM3'}));
sig=serial('COM3','BaudRate',9600,'Terminator','CR/LF');
warning('off','MATLAB:serial:fscanf:unsuccesfulRead');
fopen(sig);

%% parámetros de medidas
tmax = 10; % tiempo de captura en s
rate = 4; % resultado experimental (comprobar)

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
    v1(i)=a(1)*3.3/255;
   
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
fclose(sig);
delete(sig);
clear all;
clc;

