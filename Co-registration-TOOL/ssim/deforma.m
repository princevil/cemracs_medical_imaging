function Ta = deforma(a,griglia)
global  T Xi Yi Ti Li jmax spazio_im AIbase;
global interp_type;

% disp('sono in deforma')

[hatx,haty]=phi(griglia,a);  % applico la trasformazione alla griglia base

hatx = hatx - floor(hatx);   % periodizzazione di lato 1
haty = haty - floor(haty);




switch interp_type
    
    case 'BSpline'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quasi interpolazione con b-spline

j = max(griglia.j)-1;
dj = 2.^j;

A1 = zeros(griglia.npoints,2^j);
A2 = zeros(griglia.npoints,2^j);

for i = 1:griglia.npoints;
   xx = hatx(i); yy = haty(i);
   ixmin = ceil(dj*xx) - 1; ixmax = floor(dj*xx) + 3;
   iymin = ceil(dj*yy) - 1; iymax = floor(dj*yy) + 3;
   A1(i,ixmin:ixmax) = bspline3(dj*xx-(ixmin:ixmax) + 1);
   A1(i,iymin:iymax) = bspline3(dj*yy-(iymin:iymax) + 1);    
end

% 
% for i = 1:2^j;
%     A1(:,i)=bspline3(dj*hatx-(i-1));
%     A2(:,i)=bspline3(dj*haty-(i-1));
% end

    A1 = sparse(A1);
    A2 = sparse(A2);

Ta = zeros(griglia.npoints,1);
for i = 1:griglia.npoints
    k1 = (griglia.kx(i)+1)/2;
    k2 = (griglia.ky(i)+1)/2;
    Ta(:)=Ta(:)+Ti(iglob)*A1(:,k1).*A2(:,k2);
end


    case 'BSplineP'


j = max(griglia.j)-1;
dj = 2.^j;
Npe = dj+5;

A1 = zeros(griglia.npoints,Npe);
A2 = zeros(griglia.npoints,Npe);

% for i = 1:griglia.npoints;
%    xx = hatx(i); yy = haty(i);
%    ixmin = ceil(dj*xx)+1; ixmax = floor(dj*xx) + 5;
%    iymin = ceil(dj*yy) + 1; iymax = floor(dj*yy) + 5;
%    A1(i,ixmin:ixmax) = bspline3(dj*xx-(ixmin:ixmax) + 3);
%    A1(i,iymin:iymax) = bspline3(dj*yy-(iymin:iymax) + 3);    
% end

for i = 1:Npe;
    A1(:,i)=bspline3(dj*hatx-(i-3));
    A2(:,i)=bspline3(dj*haty-(i-3));
end

A1 = sparse(A1); A2=sparse(A2);
Ta = zeros(griglia.npoints,1);
% NB. Per le Bspline periodiche i vettori Xi e Yi contengono gli indici,
% non i centri delle funzioni
for i = 1:Npe
    for k = 1:Npe
        iglob = (k-1)*Npe+i;
    Ta(:) = Ta(:) + Ti(iglob)*A1(:,i).*A2(:,k);
    end
end

    case 'Spline'
%       disp('sono nel caso spline');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolazione spline
hatx = vector2matrix(hatx,Li);
haty = vector2matrix(haty,Li);

Ta = interp2(Xi,Yi,Ti,hatx,haty,'spline');

Ta = matrix2vector(Ta,Li);

    otherwise
    
 %       disp('sono nel caso spline');
 
 
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolazione bicubica (anche per AI)
hatx = vector2matrix(hatx,Li);
haty = vector2matrix(haty,Li);

Ta = interp2(Xi,Yi,Ti,hatx,haty,'cubic');

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





