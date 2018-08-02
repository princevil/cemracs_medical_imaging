function Ta = deforma(a,griglia)
global  T Xi Yi Ti Li jmax spazio_im AIbase;
global interp_type;

% disp('sono in deforma')

[hatx,haty]=phi(griglia,a);

hatx = hatx - floor(hatx);
haty = haty - floor(haty);

switch interp_type
    
    case 'BSpline'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quasi interpolazione con b-spline

j = max(griglia.j)-1;
dj = 2.^j;

A1 = zeros(griglia.npoints,2^j);
A2 = zeros(griglia.npoints,2^j);

for i = 1:2^j;
    A1(:,i)=bspline3(dj*hatx-(i-1));
    A2(:,i)=bspline3(dj*haty-(i-1));
end

A = zeros(griglia.npoints);
for i = 1:griglia.npoints
    k1 = (griglia.kx(i)+1)/2;
    k2 = (griglia.ky(i)+1)/2;
    A(:,i)= A1(:,k1).*A2(:,k2);
end

Ta = A*T;

    case 'BSplineP'


j = max(griglia.j)-1;
dj = 2.^j;
Npe = dj+5;

A1 = zeros(griglia.npoints,Npe);
A2 = zeros(griglia.npoints,Npe);

for i = 1:Npe;
    A1(:,i)=bspline3(dj*hatx-(i-3));
    A2(:,i)=bspline3(dj*haty-(i-3));
end

A1 = sparse(A1); A2=sparse(A2);
A = sparse(griglia.npoints,Npe^2);

% NB. Per le Bspline periodiche i vettori Xi e Yi contengono gli indici,
% non i centri delle funzioni
for i = 1:Npe
    for k = 1:Npe
        iglob = (k-1)*Npe+i;
        A(:,iglob)= A1(:,i).*A2(:,k);
    end
end
Ta = A*Ti;


    otherwise
    
 %       disp('sono nel caso spline');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolazione spline
hatx = vector2matrix(hatx,Li);
haty = vector2matrix(haty,Li);

Ta = interp2(Xi,Yi,Ti,hatx,haty,'spline');

Ta = matrix2vector(Ta,Li);

end


% % Ta = template(hatx,haty,0
% 
% % deformazione esatta
% % Ta = template(hatx,haty,0);
% 
% % per ora faccio una traslazione
% 
%  hatj = jmax*ones(griglia.npoints,1);
% % 
%  hatkx = round(2^jmax*hatx);
%  hatky = round(2^jmax*haty);
%  
% % disp([num2str(norm(a)),' - ',num2str(norm(template(hatx,haty,0)-template(griglia.x,griglia.y,0)))]);
% % 
%  hatx = hatkx/(2^jmax);
%  haty = hatky/(2^jmax);
 
 % Ta = template(hatx,haty,0);
 
 
 
% 
% hatgrid.j = hatj;
% hatgrid.kx = hatkx;
% hatgrid.ky = hatky;
% hatgrid.x=hatx;
% hatgrid.y=haty;
% hatgrid.npoints = griglia.npoints;
% M = AIoperator2d(spazio_im,hatgrid,AIbase);
% Ta = M*T;
% 
% Tacheck = template(hatx,haty,0);
% norm(Ta - Tacheck)





