function[out,buffer_FIFO]=FIFO(L,i,buffer_FIFO,in) 
   out=buffer_FIFO(2*L);
   for j=0:L
      buffer_FIFO(2*L-j)=buffer_FIFO(2*L-(j+1)); 
   end
   for j=1:L-1
      buffer_FIFO(L-(j-1))=buffer_FIFO(L-j); 
   end
  buffer_FIFO(1)=in;
end
    