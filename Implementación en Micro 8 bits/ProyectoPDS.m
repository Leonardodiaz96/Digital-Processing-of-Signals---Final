function varargout = ProyectoPDS(varargin)
% PROYECTOPDS MATLAB code for ProyectoPDS.fig
%      PROYECTOPDS, by itself, creates a new PROYECTOPDS or raises the existing
%      singleton*.
%
%      H = PROYECTOPDS returns the handle to a new PROYECTOPDS or the handle to
%      the existing singleton*.
%
%      PROYECTOPDS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROYECTOPDS.M with the given input arguments.
%
%      PROYECTOPDS('Property','Value',...) creates a new PROYECTOPDS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ProyectoPDS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ProyectoPDS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ProyectoPDS

% Last Modified by GUIDE v2.5 18-Apr-2023 19:38:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProyectoPDS_OpeningFcn, ...
                   'gui_OutputFcn',  @ProyectoPDS_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ProyectoPDS is made visible.
function ProyectoPDS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProyectoPDS (see VARARGIN)

% Choose default command line output for ProyectoPDS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ProyectoPDS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ProyectoPDS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% filename=uigetfile('*.mat*','Abre un archivo .mat');
% command=sprintf('load(''%s'')',filename);
% evalin('base',command);
[file,folder]=uigetfile('*.mat*','Abre un archivo .mat');
filename=fullfile(folder,file);
data=load(filename)
Fs=data.Fs;
s=data.s;

handles.s=s;
guidata(hObject,handles);
%Inicializacion de parametros para las señales ECG
ns=0:length(s)-1;      %Barrido de tiempo igual al numero de datos adquiridos
ns=ns*1/Fs;   %Normalizacion por T=1/Fs



axes(handles.axes1)
title('Senial ECG')
xlabel('tiempo [seg]')
ylabel('Muestras [mV]')

set(gcf,'Color',[.53 .53 .53]);
set(gca,'Color','k');

umbral_y=6*mean(abs(s));
umbral_x=0.3*Fs;
%Findpeaks
[pks,locs]=findpeaks(s,'MinPeakHeight',umbral_y,'MinPeakDistance',umbral_x);




a=tic;

h=animatedline('Color','red','Linewidth',2);
%%%%%SONIDO%%%%%
A=440;
FF=5000;
T=0:1/FF:0.3;
X=sin(2*pi*A*T);
%%%%%%%%%%%%%%%%


for k= 1:length(s)

%     if(k>3 && axis_y(k)==0 && axis_y(k-1)==0 && axis_y(k-2)==0 )

%     end

    if ismember(k,locs) 
%        set(plot(axis_x(k),axis_y(k),'o','Color','b'))
       sound(X)
%        hold on
       
    else
    
    addpoints(h,ns(k),s(k));
    
    if k<=600
        axis([0,0.7488,-0.4,1.4])
    else
        axis([ns(k-600),ns(k),-0.4,1.4])
    end


    b=toc(a);

    if b>(1/15)
        drawnow 
        a=tic;
    end
    
    end
    

end
drawnow 





% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Fs=800;
s=handles.s;

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

for i=1:length(s)
    [salida_LIFO1,buffer_LIFO1,j,flag,BLOQUE]=LIFO(i,j,flag,buffer_LIFO1,s,BLOQUE);
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

end

axes(handles.axes2)
title('Senial Filtrada ECG')
xlabel('tiempo [seg]')
ylabel('Muestras [mV]')

set(gcf,'Color',[.53 .53 .53]);
set(gca,'Color','k');

umbral_y=6*mean(abs(signal_salida));
umbral_x=0.3*Fs;
%Findpeaks
[pks,locs]=findpeaks(signal_salida,'MinPeakHeight',umbral_y,'MinPeakDistance',umbral_x);




a=tic;

h=animatedline('Color','green','Linewidth',2);
%%%%%SONIDO%%%%%
A=440;
FF=5000;
T=0:1/FF:0.3;
X=sin(2*pi*A*T);


T2=0:1/FF:20;
X2=sin(2*pi*A*T2);
%%%%%%%%%%%%%%%%

    if(signal_salida(1)==0 && signal_salida(2)==0 && signal_salida(3)==0 )
    sound(X2)
    end

flag=0;

for k= 1:length(signal_salida)

    if signal_salida(k) ~= 0 && flag==0
        clear sound;
        flag=1;
    end

    if ismember(k,locs) 

       sound(X)

       
    else
    
    addpoints(h,ns(k),signal_salida(k));
    
    if k<=600
        axis([0,0.7488,-0.4,1.4])
    else
        axis([ns(k-600),ns(k),-0.4,1.4])
    end


    b=toc(a);

    if b>(1/15)
        drawnow 
        a=tic;
    end
    
    end
    

end
drawnow 

