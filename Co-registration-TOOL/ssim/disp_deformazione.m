function disp_deformazione(a,griglia)
global T jmax spazio_im AIbase Li;

[hatx,haty]=phi(griglia,a);

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
 
 z = checkb(hatx,haty);
 imshow(vector2matrix(z,Li));
 
 
 
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





