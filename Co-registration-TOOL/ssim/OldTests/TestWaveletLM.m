clear all
global spazio spazio_im griglia R Xi Yi Ti Dxi Dyi Li Mass jmax AIbase
 
figure(1); clf
%jmax: risoluzione con cui si valuta PHI

jmax=10;

base=start(3,9);
AIbase=AIstart(4,jmax);

j = 8; 
griglia = quadgrid(j); % "pixel"


% R = imread('Images/africasculpt128_T1.jpg');
R = imread('Images/facet256_T.jpg');

R = double(R)/256;

% T = imread('Images/africasculpt128.jpg');
T = imread('Images/facet256.jpg');

T = double(T)/256;

S = conv2 (T, ones (5, 5) / 25, 'same');
[Dxi, Dyi] = gradient (S);



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
subplot(2,2,1); imshow(R); title('Reference image');
subplot(2,2,2); imshow(T); title('Template image');


T = matrix2vector(Ti,Li);
R = matrix2vector(R,Li);

spazio_im = uniformAIspace2d(j);


spazio = uniform2d(2,2); % "trasformazioni"

Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base);

disp('costruito operatore di massa');

% th=.3;
% a0 = [0; cos(th)-1; -sin(th); cos(th)-1-sin(th);...
%   -.2; sin(th)-.2;cos(th)-1.2; sin(th)+cos(th)-1.2] +.1*rand(8,1);
a0 = zeros(2*spazio.npoints,1);



options=optimset('GradObj','off',... %'HessUpdate','steepdesc',
    'MaxFunEvals',10000,'DerivativeCheck','off',...
     'TolFun',.00001,'TolX',1.e-5,...  %'DiffMinChange',1.e-4,
    'Display','iter','PlotFcns',@optimplotfval,...
    'Algorithm','levenberg-marquardt');
 
problem.objective = @costoLM;
problem.x0 = a0;
problem.solver = 'lsqnonlin';
problem.options = options;
% % options=optimset('GradObj','off','MaxFunEvals',1000,'DerivativeCheck','on')
 [a1,fval,exitflag,output] = lsqnonlin(problem);
 
% grad 
 
T1 = deforma(a1,griglia);
figure(1);
subplot(2,2,3); imshow(vector2matrix(T1,Li));title('Optimization with FD gradient');

subplot(2,2,4)
disp_deformazione(a1,griglia);
% options=optimset('GradObj','on','MaxFunEvals',300,'DerivativeCheck','off',...
%     'TolFun',1.e-6,'TolX',1.e-6,'DiffMinChange',1.e-5,'Display','iter',...
%     'PlotFcns',@optimplotfval,'LargeScale','on');
% a2 = fminunc(@costo,a1,options);
% T2 = deforma(a2,griglia);
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
