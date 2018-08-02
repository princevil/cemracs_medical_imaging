function griglia = quadgrid(J)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

griglia.npoints=4^J;

griglia.j = (J+1)*ones(griglia.npoints,1);

v=(1:2:2*2^J-1);
ky=repmat(v,2^J,1);
ky=reshape(ky,4^J,1);
kx=repmat(v',1,2^J);
kx=reshape(kx,4^J,1);

% griglia.j(1:(2^j0+1)^2)=j0*ones((2^j0+1)^2,1);
griglia.kx=kx;
griglia.ky=ky;
griglia.x = griglia.kx./(2.^griglia.j);
griglia.y = griglia.ky./(2.^griglia.j);


end

