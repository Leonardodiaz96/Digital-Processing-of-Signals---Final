
x=(1:25);
L=5;
buffer_LIFO1=zeros(1,L); %buffer LIFO1
buffer_LIFO2=zeros(1,L); %buffer LIFO2
buffer_FIFO=zeros(1,2*L); %buffer FIFO

signal_salida=zeros(1,length(x));
j=1;
flag=1;

j2=1;
flag2=1;

salida_LIFO1=0;
salida_H1=0;
salida_H2=0;
salida_FIFO=0;
salida_LIFO2=0;
SUMA=0;
salida_H3=0;

BLOQUE=1;

tiempo=linspace(1,L,L);
tiempo2L=linspace(1,2*L,2*L);
fp=1;
fp2=1;

for i=1:length(x)
    
    
    
    [salida_LIFO1,buffer_LIFO1,j,flag,BLOQUE]=LIFO_f(i,j,flag,buffer_LIFO1,x,BLOQUE);
    
    %%%%%%%%
    if(flag==1)
        [salida_H1]=H1_f(0);
        [salida_H2]=H2_f(salida_LIFO1);
        [salida_FIFO,buffer_FIFO]=FIFO_f(L,i,buffer_FIFO,salida_H2);
        SUMA=salida_FIFO+salida_H1;
    else
        [salida_H1]=H1_f(salida_LIFO1);
        [salida_H2]=H2_f(0);
        [salida_FIFO,buffer_FIFO]=FIFO_f(L,i,buffer_FIFO,salida_H1);
        SUMA=salida_FIFO+salida_H2;
    end
    %%%%%%%%
    
    [salida_LIFO2,buffer_LIFO2,j2,flag2]=LIFO2_f(j2,flag2,buffer_LIFO2,SUMA);
    [salida_H3]=H3_f(salida_LIFO2);
    
    signal_salida(i)=salida_H3;
    
    

fprintf('\t\t\t\t\t\tBLOQUE: %d \n\n',BLOQUE);
fprintf('\tbuffer_LIFO1:\t %s \n',sprintf('|%d| ',buffer_LIFO1));
fprintf('\tsalida_LIFO1:\t %d \n',salida_LIFO1);

fprintf('\tsalida_H1:\t     %d \n',salida_H1);
fprintf('\tsalida_H2:\t     %d \n',salida_H2);


fprintf('\tbuffer_FIFO:\t %s \n',sprintf('|%d| ',buffer_FIFO));
fprintf('\tsalida_FIFO:\t %d \n',salida_FIFO);

fprintf('\tSUMA:\t         %d \n',SUMA);


fprintf('\tbuffer_LIFO2:\t %s \n',sprintf('|%d| ',buffer_LIFO2));
fprintf('\tsalida_LIFO2:\t %d \n',salida_LIFO2);

fprintf('\tsalida_H3:\t     %d \n\n',salida_H3);
fprintf('---------------------------------------------------------\n');



    
end


