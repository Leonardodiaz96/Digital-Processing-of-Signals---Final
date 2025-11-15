function[out,buffer_LIFO2,j2,flag2]=LIFO2(j2,flag2,buffer_LIFO2,in)
   if(j2<1)
        flag2=1; 
        j2=j2+1;                    %j=1
   end
    if(j2>length(buffer_LIFO2))
        flag2=0; 
        j2=j2-1;                    %j=L
    end
    if(flag2==1)                    %Ascendente
        out=buffer_LIFO2(j2);
        buffer_LIFO2(j2)=in;
        j2=j2+1;
    end
    if(flag2==0)                    %Descendente
        out=buffer_LIFO2(j2);
        buffer_LIFO2(j2)=in;
        j2=j2-1;
    end
end