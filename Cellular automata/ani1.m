%ani1: first example on smooth animations

clear all;
close all;
figure(1);
clf;

oldcmap = colormap;
colormap([1 1 1;0 0 0]);

n=50;
state=ones(n,n);
for iter=1:n,
   state(iter,iter)=2;
   image(state);
end;
