function[out,buffer_LIFO,j,flag,BLOQUE]=LIFO(i,j,flag,buffer_LIFO,signal,BLOQUE)
   if(j<1)
        flag=1; 
        j=j+1;                  %j=1
        BLOQUE=BLOQUE+1;

    end
    if(j>length(buffer_LIFO))
        flag=0; 
        j=j-1;                  %j=L
        BLOQUE=BLOQUE+1;
    end
    if(flag==1)                 %Ascendente
        out=buffer_LIFO(j);     
        buffer_LIFO(j)=signal(i);
        j=j+1;
    end
    if(flag==0)                 %Descendente
        out=buffer_LIFO(j);
        buffer_LIFO(j)=signal(i);
        j=j-1;
    end
end