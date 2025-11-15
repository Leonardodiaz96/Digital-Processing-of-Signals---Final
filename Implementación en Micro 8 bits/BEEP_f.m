A=440;
FF=5000;
T=0:1/FF:20;
X=sin(2*pi*A*T);
% 
% % ap=audioplayer(X,FF);
% % playblocking(ap);
% 
% % wavplay(X,FF,'sync'
% 
sound(X,FF)
% % plot(T,X)
% % axis([0,0.1,-1,1])
% 
for i=0:1/FF:6
    i
    if i>3
    clear sound;
    
    end
%     wavplay(X,FF,'sync')
end
% 
% % load handel
% % ap=audioplayer(y,Fs);
% % playblocking(ap);

% 
% load chirp;
% y1=y;Fs1=Fs;
% load gong;
% wavplay(y1,Fs1,'sync')
% wavplay(y,Fs)