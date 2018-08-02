function [stiffb,fb]=appendbc(stiff,mass,f,grid);

stiffb=stiff;
ib=logical(grid(:,4));
stiffb(ib,:)=mass(ib,:);
fb=f;
fb(ib)=0*fb(ib);


