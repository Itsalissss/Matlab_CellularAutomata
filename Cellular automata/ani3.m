%ani3: third example on smooth animations

clear all;
close all;
figure(1);
clf;

set(gcf,'doublebuffer','on');

colormap([1 1 1;0 0 0]);

n=50;
state=ones(n,n);
for iter=1:n,
   state(iter,iter)=2;
   image(state);
   drawnow;
end;
