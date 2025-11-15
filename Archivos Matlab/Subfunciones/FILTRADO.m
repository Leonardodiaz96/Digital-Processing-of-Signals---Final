function[out_sample,z]=FILTRADO(num,den,in_sample,z)
    out_sample=num(1)*in_sample+z(1);
    for i=2:n
        z(i-1)=num(i)*in_sample+z(i)-den(i)*out_sample;
    end
end