%% CREACION DE ARCHIVO .txt PARA GENERAR SEÑAL EN EL DAC

load('ECG_senal_1a.mat')
%Agrego una componente de continua a la señal
% minim=min(s); %-0.4123

senialECG=zeros(1,5000);
senialECG=s+0.42;
% min(senialECG)%0.0077
% max(senialECG)%1.7759

%1.78______255
%senial____bit
%bit=senial*255/1.78

senialECG=round(senialECG*255/1.78);
% 
% t=1:5000;
% plot(t,senialECG)

fid=fopen('D:\FACULTAD 2021\PDS\FINAL\Proyecto Integrador - ANCE, ARNEDO, DIAZ y PEREYRA\ECGPDS.txt','w');
for k=1:5000
fprintf(fid,'%i,',senialECG(k));
end
fclose(fid);