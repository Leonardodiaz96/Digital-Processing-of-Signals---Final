function[]=Plotear_Senial(axis_x,axis_y)

%Visualizamos la senial ECG
comet(axis_x,axis_y,0);
title('Senial ECG')
xlabel('tiempo [seg]')
ylabel('Muestras [mV]')
hold on

end