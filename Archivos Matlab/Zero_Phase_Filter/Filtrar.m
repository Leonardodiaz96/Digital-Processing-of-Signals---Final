function[muestra_salida,z]=Filtrar(b,a,muestra_entrada,z)
    n=length(a);
    z(n)=0;
    
%Normalizamos los polinomios numerador y denominador
    b=b/a(1);
    a=a/a(1);
    
    muestra_salida=b(1)*muestra_entrada+z(1);
    for i=2:n
      z(i-1)=b(i)*muestra_entrada+z(i)-a(i)*muestra_salida;
    end
    z=z(1:n - 1);
end