function [J,DJ,HJ] = costo(a)
global griglia R

global hvs

Ta = deforma(a,griglia);
gradTa = gradiente(a,griglia);
% hessTa = hessiano(a,griglia);


Np = sqrt(griglia.npoints);



% if(~exist('hvs'))
ris = 53.5; dist = 45;
x = 0:Np-1; [X,Y] = meshgrid(x,x);
r = ris * dist * pi * sqrt(X.^2 + Y.^2) / (Np * 360);
% hvs = (.2+0.45*(5.1*r/9).^2).*exp(-0.18*(5.1*r/9).^2);
hvs = (.2+.25*r).^2.*exp(-.2*r);
% end

Ta1 = reshape(Ta,Np,Np)'; R1 = reshape(R,Np,Np)';


Ta1 = dct2(Ta1); R1 = dct2(R1); 

Ta1 = hvs.*Ta1; R1 = hvs.*R1;
Ta1 = idct2(Ta1); R1 = idct2(R1);
Ta1 = reshape(Ta1',Np^2,1); R1 = reshape(R1',Np^2,1);
 
J = .5*(Ta1-R1)'*(Ta-R)/griglia.npoints;
N=max(size(a)); DJ = zeros(N,1);

HJ = [];

for j = 1:N,
        DJ(j) = (Ta1 - R1)'*gradTa(:,j)/griglia.npoints;
end
