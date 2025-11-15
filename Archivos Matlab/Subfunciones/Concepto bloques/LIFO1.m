function[salida]=LIFO1(i,j,buffer_size,signal)

if(i==0)
    i=i+1;
    while(i<=buffer_size && j<=length(signal))
        buffer(i)=signal(j);
        i=i+1;
        j=j+1;
    end
else
    i=i-1;
    while(i>=1 && j<=length(signal))
        buffer(i)=signal(j);
        i=i-1;
        j=j+1;
    end
end

end