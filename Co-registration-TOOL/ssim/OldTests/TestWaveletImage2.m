clear all
global spazio spazio_im griglia T R Xi Yi Ti Dxi Dyi Li Mass jmax AIbase
global interp_type cost_function

stringa = datestr(now,30);

filename1 = ['Tests/',stringa,'-convhist1'];
filename2 = ['Tests/',stringa,'-convhist2'];
filename3 = ['Tests/',stringa,'-result'];
filename4 = ['Tests/',stringa,'-diary'];

diary(filename4);

interp_type = 'Spline';
cost_function = 'SSIM2';

addpath('C:\Users\Silvia\Dropbox\bspline_tools_1_2\'); 

figure(1); clf
%jmax: risoluzione con cui si valuta PHI

jmax=10;

nw = 3; j0 = 2; jwi = 2;
disp(['Trasformazione: wavelet interpolanti - nw = ',num2str(nw),' - j0 = ',num2str(j0),...
    ' - J = ',num2str(jwi)]);

base=start(nw,9);
spazio = uniform2d(j0,jwi); % "trasformazioni"

AIbase=AIstart(4,jmax);

j = 6; 
griglia = quadgrid(j); % "pixel"

% disp('Immagine = africasculpt256')
% R = imread('Images/africasculpt256_T1.jpg');
% T = imread('Images/africasculpt256.jpg');



disp('Immagine = africasculpt64')
R = imread('Images/africasculpt64_T.jpg');
T = imread('Images/africasculpt64.jpg');

R = double(R)/256;T = double(T)/256;

S = T;
% S = conv2 (T, ones (3, 3) / 9, 'same');
[Dxi, Dyi] = periodic_gradient (S,1/(2^j));




% R = reference(griglia.x,griglia.y);
% T = template(griglia.x,griglia.y,0);

h = 1/2.^j;

xt=(h/2:h:1-h/2);
yt=(h/2:h:1-h/2);


% dati per l'interpolazione
[Xi,Yi]=meshgrid(xt,yt);

Li = griddata(griglia.x,griglia.y,(1:griglia.npoints)',Xi,Yi);
Ti = T;

figure(1)
subplot(3,2,1); imshow(R); title('Reference image');
subplot(3,2,2); imshow(T); title('Template image');




T = matrix2vector(T,Li);
R = matrix2vector(R,Li);

spazio_im = uniformAIspace2d(j);


Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base);

disp('costruito operatore di massa');

% th=.3;
% a0 = [0; cos(th)-1; -sin(th); cos(th)-1-sin(th);...
%   -.2; sin(th)-.2;cos(th)-1.2; sin(th)+cos(th)-1.2] +.1*rand(8,1);
a0 = zeros(2*spazio.npoints,1);


options=optimset('GradObj','on',... %'HessUpdate','steepdesc',
    'MaxFunEvals',10000,'DerivativeCheck','on',...
     'TolFun',.00001,'TolX',1.e-5,...  %'DiffMinChange',1.e-4,
    'Display','final','PlotFcns',@optimplotfval,...
     'LargeScale','off');
% % options=optimset('GradObj','off','MaxFunEvals',1000,'DerivativeCheck','on')
 [a1,fval,exitflag,output1] = fminunc(@costo,a0,options);
 print('-depsc',filename1);
% grad 
 
 options=optimset('GradObj','on','MaxFunEvals',300,'DerivativeCheck','off',...
     'TolFun',1.e-6,'TolX',1.e-6,'DiffMinChange',1.e-5,'Display','final',...
     'PlotFcns',@optimplotfval,'LargeScale','on');
 [a1,fval,exitflag,output2] = fminunc(@costo,a1,options);
 print('-depsc',filename2);
 
 T1 = deforma(a1,griglia);
figure(1);
subplot(3,2,5); imshow(vector2matrix(T1,Li));title('Transformed template image');

subplot(3,2,6)
disp_deformazione(a1,griglia);title('Transformation')
 
 S=zeros(2^j,2^j,3);
 S(:,:,1)=vector2matrix(R,Li);
 S(:,:,2)=vector2matrix(T,Li);
 subplot(3,2,3); imshow(S);title('Reference vs Template')

 T1 = min(T1,1); T1 = max(T1,0);
 S(:,:,2)=vector2matrix(T1,Li);
  subplot(3,2,4); imshow(S);title('Reference vs transformed Template');
print('-depsc',filename3);

 % figure(1)
% subplot(2,2,4); plot2d(T2,griglia);view(2);title('Optimization with user gradient');
% a2

% %Versione multiscala weak
% 
% disp('inizia versione multiscala')
% spazio = uniform2d(0,0);
% a0 = zeros(2*spazio.npoints,1);
% Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base);
% options=optimset('GradObj','off','MaxFunEvals',1000,'DerivativeCheck','off',...
%     'TolFun',1.e-10,'TolX',1.e-10,'LargeScale','off')
% % options=optimset('GradObj','off','MaxFunEvals',1000,'DerivativeCheck','on')
% a3 = fminunc(@costo,a0,options);
% disp('fine step 1')
% 
% spazio = uniform2d(0,1);
% a0 = zeros(2*spazio.npoints,1);
% a0(1:8)=a3;
% Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base);
% options=optimset('GradObj','off','MaxFunEvals',1000,'DerivativeCheck','off',...
%     'TolFun',1.e-10,'TolX',1.e-10,'LargeScale','off')
% % options=optimset('GradObj','off','MaxFunEvals',1000,'DerivativeCheck','on')
% a4 = fminunc(@costo,a0,options);
% T3  = deforma(a2,griglia);
% 

output1

output2

disp(['Interpolation : ',interp_type]);
disp(['Cost function : ',cost_function]);

disp(['Costo least square = ',num2str(costoLS(a1))]);
disp(['Costo least square normalizzato = ',num2str(costoLS(a1))]);
disp(['Costo SSIM (p=1) = ',num2str(costossim(a1,1))]);
disp(['Costo SSIM (p=2) = ',num2str(costossim(a1,2))]);
disp(['Costo SSIM (p=3) = ',num2str(costossim(a1,3))]);

diary off;
