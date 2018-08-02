function [J,DJ,HJ] = costoWNRMSE(a,p)
global griglia R maxlev wname Li besov_q


% disp('sono in costo wavelet')

% a: parametri della trasformazione
% parametro della metrica

c = .01;
if(nargin==1)
p=besov_q;
end

j = max(griglia.j);

Mask = zeros(griglia.npoints,maxlev);

global hvs

Ta = deforma(a,griglia);
gradTa = gradiente(a,griglia);
% hessTa = hessiano(a,griglia);

Np = sqrt(griglia.npoints);



% if(~exist('hvs'))
ris = 53.5; dist = 45;
x = 0:Np-1; [X,Y] = meshgrid(x,x);
r = ris * dist * pi * sqrt(X.^2 + Y.^2) / (Np * 360);
hvs = (.2+0.45*(5.1*r/9).^2).*exp(-0.18*(5.1*r/9).^2);
% end

Ta1 = reshape(Ta,Np,Np)'; R1 = reshape(R,Np,Np)';

[Ta1,ST]=wavedec2(Ta1,maxlev,wname);
[R1,SR]=wavedec2(R1,maxlev,wname);

lev = ones(size(Ta1));
lev(1:ST(1,1)*ST(1,2)) = (j-maxlev)*lev(1:ST(1,1)*ST(1,2));

N0 = ST(1,1)*ST(1,2);
for  i = 1:maxlev
    N1 = 3*ST(i+1,1)*ST(i+1,2);
    lev(N0+1:N0+N1)=(j-maxlev+i-1)*lev(N0+1:N0+N1); 
    Mask(N0+1:N0+N1,i)=ones(N1,1);
    N0 = N0 + N1;
end

N = max(size(a));

J = 0;
DJ = zeros(N,1);

for ilev = 1:maxlev
Ta2 = Mask(:,ilev)'.*Ta1; R2 = Mask(:,ilev)'.*R1;
 
Ta2 =  waverec2(Ta2,ST,wname); 
Ta2 = reshape(Ta2',Np*Np,1);


R2=waverec2(R2,SR,'haar');
R2 = reshape(R2',Np*Np,1);


J1 = ((Ta2-R2)'*(Ta-R)/griglia.npoints);
J2 = (Ta2'*Ta + R2'*R)/griglia.npoints + c;
JJ = (J1/J2);
J = J + JJ^(p/2);


N=max(size(a));

HJ = [];

DJ1 = zeros(N,1);
DJ2 = zeros(N,1);


for j = 1:N,
        DJ1(j) = 2*(Ta2 - R2)'*gradTa(:,j)/(griglia.npoints);
        DJ2(j) = 2*Ta2'*gradTa(:,j)/(griglia.npoints);
end

DJ = DJ + p*JJ^(p/2-1)*(DJ1*J2-J1*DJ2)/(2*(J2)^2);
end
%end for ilev


DJ = J^(1/p-1)*DJ/p;
J = J^(1/p);

end %end function