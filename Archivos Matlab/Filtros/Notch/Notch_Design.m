function[num,den]=Notch_Design(Fc_analog,sample_freq,AB)

% Calculo de la Frecuencia de corte digital
DT_notch_freq_zero=2*pi*Fc_analog/sample_freq;

% Calculo del radio para un ancho de banda AB
r=1-(AB*pi/sample_freq);

DT_notch_freq_pole=acos(((1+r.^2)*cos(DT_notch_freq_zero))/(2*r));
notchzeros = [exp(1i*DT_notch_freq_zero) exp(-1i*DT_notch_freq_zero)];
notchpoles = [r*exp(1i*DT_notch_freq_pole) r*exp(-1i*DT_notch_freq_pole)];

b=poly(notchzeros);
K=(1+r.^2)/2;
num=K*b;
den=poly(notchpoles);

end