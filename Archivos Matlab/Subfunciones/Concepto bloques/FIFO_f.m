function[out,buffer_FIFO]=FIFO_f(L,i,buffer_FIFO,in) 

%    L=length(buffer_FIFO)/2;
   out=buffer_FIFO(2*L);
   for j=0:L
      buffer_FIFO(2*L-j)=buffer_FIFO(2*L-(j+1)); 
   end
   for j=2:L-1
      buffer_FIFO(L-(j-1))=buffer_FIFO(L-j); 
   end
  buffer_FIFO(1)=in;
  
end
    