function [stiffb,fb]=appendbc2d(stiff,mass,f,grid);

stiffb=stiff;
ib=logical(grid.b);
stiffb(ib,:)=mass(ib,:);
size(stiff)
size(f)
size(ib)
fb=f;
fb(ib)=0*f(ib);


