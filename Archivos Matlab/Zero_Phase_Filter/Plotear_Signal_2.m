function[]=Plotear_Signal_2(axis_x,axis_y)

title('Senial ECG')
xlabel('tiempo [seg]')
ylabel('Muestras [mV]')

Fs=800;
umbral_y=6*mean(abs(axis_y));
umbral_x=0.3*Fs;

%Find peaks
[pks,locs]=findpeaks(axis_y,'MinPeakHeight',umbral_y,'MinPeakDistance',umbral_x);

a=tic;

h=animatedline('Color','red','Linewidth',2);

%Tones for each signal levels
A=440;
FF=5000;
T=0:1/FF:0.3;
X=sin(2*pi*A*T);

T2=0:1/FF:20;
X2=sin(2*pi*A*T2);

if(axis_y(1)==0 && axis_y(2)==0 && axis_y(3)==0 )
    sound(X2)
end

flag=0;
    
for k= 1:length(axis_y)
    if axis_y(k) ~= 0 && flag==0
        clear sound;
        flag=1;
    end
    if ismember(k,locs) 
       sound(X)
    else
       addpoints(h,axis_x(k),axis_y(k));
    if k<=600
        axis([0,0.7488,-0.4,1.4])
    else
        axis([axis_x(k-600),axis_x(k),-0.4,1.4])
    end
    b=toc(a);
    if b>(1/15)
        drawnow 
        a=tic;
    end
    end
end
drawnow 
end