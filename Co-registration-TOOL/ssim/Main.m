%%%% Main %%%%

clear all
addpath('../haar')
addpath('../WaveletBases')

global spazio spazio_im griglia T R Xi Yi Ti Dxi Dyi Li Mass jmax AIbase
global interp_type cost_function
global wname maxlev% wavelet da usare per il calcolo della norma Besov.
global hvs
global besov_q;
global Nsample Kmi;

 startmode = 'zero'; % base nodale
% startmode = 'multiscale'; 



% Level of the image - 2^j x 2^j (max 9 for the image we have)
j = 7;




nrefine=2;
interp_type = 'AI';
% interp_type = 'Cubic';

cost_function = 'LS'
% cost_function = 'WNRMSE'; 




% besov_q = 10;

Kmi=3; Nsample = 32;
maxit=500;

% noise_type = 'gaussian';
 noise_type = 'none';


% image

nome_immagine = 'africasculpt';
% nome_immagine = 'facet';

maxlev=j;

% AI wavelet for the description of the image
D = 6;

% Transormations
% nw=1; j0=0; j1=0;  % Q1 tranformation

nw = 3; j0 = 2; jwi = 2; % nw = degree of polynomial interpolation

if(strcmp(startmode,'multiscale'))
load a2;
a0=a1;
else
a0 = zeros(2*(2^jwi+1)^2,1);
end

#{
directory = ['TestTR/',interp_type,num2str(nrefine),'-',cost_function];
if(strcmp(cost_function,'Besov'))
    directory = [directory,num2str(besov_q)];
end
% directory=[directory,'-',noise_type];

mkdir(directory);
nome_immagine = 'africasculpt';
% nome_immagine = 'facet'; it is the name of the image file

stringa = datestr(now,30)
stringa = [stringa,'-',num2str(j)];

filename1 = [directory,'/',stringa,'-convhist1'];
filename2 = [directory,'/',stringa,'-convhist2'];
filename3 = [directory,'/',stringa,'-result'];
filename4 = [directory,'/',stringa,'-diary.txt'];
filename5 = [directory,'/',stringa,'-data.mat'];

diary(filename4);


disp(['Interpolation : ',interp_type,' - nrefine = ',num2str(nrefine)]);
disp(['Cost function : ',cost_function]);
#}

addpath('C:\Users\Silvia\Dropbox\bspline_tools_1_2\'); 

figure(1); clf
% jmax: resolution to evaluate PHI




% Initialization of the space of transformations
jmax=9;
disp(['Trasformazione: wavelet interpolanti - nw = ',num2str(nw),' - j0 = ',num2str(j0),...
    ' - J = ',num2str(jwi)]);
if(strcmp(cost_function,'MI'))
    disp(['K = ',num2str(Kmi),' - Nsample = ',num2str(Nsample)]);
end

base=start(nw,jmax);
spazio = uniform2d(j0,jwi); % "trasformazioni"; transf. grid
griglia = quadgrid(j); % "pixel"; pixel grid
% Operator evaluating space functions onto grid nodes
Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base); % only relevant in a multiscale case
disp('costruito operatore di massa');





% grid which the image is defined on

h = 1/2.^j;

nome_template = ['Images/',nome_immagine,num2str(2^j),'.jpg']; 
nome_reference = ['Images/',nome_immagine,num2str(2^j),'_T.jpg']; 




%% CONSTRUCTION OF NOISE


%% INITIALIZATION OF THE IMAGE
disp(['Immagine = ',nome_immagine,num2str(2^j)]);
R = imread(nome_reference);

Rclean = double(R)/256;
T = imread(nome_template);

R = double(R)/256;T = double(T)/256;


% Data for describing T from a matrix to a vector;
% This is not a mandatory trick: one can surely do better than this.

% matrix2vector(T,Li)=reshape(T',Np,Np); 
% vector2matrix=reshape(T,Np^2,1)';
% (Np = #points in any of two directions)


xt=(h/2:h:1-h/2);
yt=(h/2:h:1-h/2);
[Xt,Yt]=meshgrid(xt,yt);
Li = griddata(griglia.x,griglia.y,(1:griglia.npoints)',Xt,Yt);
Li = round(Li);
%% Here Li basically counts the grid points


N = 2^j;
% Xi = Xt; Yi = Yt; Ti = T;

%% Data construction for the Spline or Bi-cubic interpolation
if(strcmp(interp_type,'Spline')|strcmp(interp_type,'Cubic'))
  
    hf = h/(2.0^nrefine);
    xe=(-3*h/2:h:1+3*h/2);
    ye = xe;
    [Xe,Ye]=meshgrid(xe,ye);

    Te = [T(:,N-1) T(:,N), T, T(:,1) T(:,2)];
    Te = [Te(N-1,:); Te(N,:); Te; Te(1,:); Te(2,:); ];

    xf = (-3*hf/2:hf:1+3*hf/2);
    yf = xf;
    [Xf,Yf]=meshgrid(xf,yf);
    Tf = interp2(Xe,Ye,Te,Xf,Yf);
    Xi = Xf; Yi = Yf; Ti = Tf;

    S = Ti;
    % S = conv2 (T, ones (3, 3) / 9, 'same');
    [Dxi, Dyi] = gradient(S,hf);

end

 
%% Data construction for the AI interpolation
if (strcmp(interp_type,'AI'))
    
    AIbase=AIstart(D,jmax);
    AIspace = uniformAIspace2d(j,D); %This is the space which represents
                                     %the image with periodic extension.
    % Data for the describing T from a matrix to vector;
    % Again: one can do better than this.


    % Xi = Xt; Yi = Yt; Ti = T;

    % Construction for the cost function and its gradient
    % Periodic extension of T

    Te = [T(:,N-D+1:N), T, T(:,1:D)]; 
    Te = [Te(N-D+1:N,:); Te; Te(1:D,:)];

    Te = Te';

    AIspace1d = uniformAIspace1d(j,D);
    cgrid1d = uniform1d(j+nrefine);
    [A,DA] = AIoperator1d(AIspace1d,cgrid1d,AIbase);

    Ti = A*Te'*A';
    Dyi = DA*Te'*A';
    Dxi = A*Te'*DA';

    % Te is the vector in AIspace corrensponding to T

    cgrid = uniform2d(j+nrefine,j+nrefine);

    %[Ti,Dxi,Dyi] = applyAIoperator2d(Te,AIspace,cgrid,AIbase);
    Xi = reshape(cgrid.x,2^(j+nrefine)+1,2^(j+nrefine)+1)';
    Yi = reshape(cgrid.y,2^(j+nrefine)+1,2^(j+nrefine)+1)';
    %Ti = reshape(Ti,2^(j+nrefine)+1,2^(j+nrefine)+1)';
    %Dxi = reshape(Dxi,2^(j+nrefine)+1,2^(j+nrefine)+1)';
    %Dyi = reshape(Dyi,2^(j+nrefine)+1,2^(j+nrefine)+1)';
end    

#{
if(strcmp(interp_type,'BSplineP'))
%% Data contruction for the periodic BSpline interpolation
    disp('costruzione dati interpolazione Bspline periodica');
    hf = h/(2.0^nrefine);
    kxe =[-2:2^j+2];
    kye = kxe;
 %  xe=(-3*h/2:h:1+3*h/2);
 %   ye = xe;
    [Kxe,Kye]=meshgrid(kxe,kye);

    Te = [T(:,N-1) T(:,N), T, T(:,1) T(:,2) T(:,3)];
    Te = [Te(N-1,:); Te(N,:); Te; Te(1,:); Te(2,:); Te(3,:)];
    Npe = 2^j+5;
    Ti = reshape(Te',Npe^2,1);

    
end
#}

% disp('Fine interpolazioni'); pause


figure(1)
subplot(2,3,1); imshow(R); title('Reference image');
subplot(2,3,2); imshow(T); title('Template image');


disp('2')


T = matrix2vector(T,Li);
R = matrix2vector(R,Li);




% th=.3;
% a0 = [0; cos(th)-1; -sin(th); cos(th)-1-sin(th);...
%   -.2; sin(th)-.2;cos(th)-1.2; sin(th)+cos(th)-1.2] +.1*rand(8,1);


c0 = costo(a0);
tolerance = c0/200;



%"FunValCheck", "OutputFcn", "TolX", "TolFun", "MaxIter", 
%"MaxFunEvals", "GradObj", "FinDiffType", "TypicalX", "AutoScaling".



t = cputime;



% switch opt_algorithm
%
%    case 'QuasiNewton'
% options=optimset('GradObj','on',...%'HessUpdate','steepdesc',...
%    'MaxIter',maxit,'DerivativeCheck',der_control,...
%     'TolFun',1.e-6,'TolX',1.e-6,...  %'DiffMinChange',1.e-4,
%    'Display','final','PlotFcns',@optimplotfval,...
%     'LargeScale','off');
%% % options=optimset('GradObj','off','MaxFunEvals',1000,'DerivativeCheck','on')
% [a1,fval,exitflag,output] = fminunc(@costo,a0,options);
% 
%% grad 
%    otherwise
% options=optimset('GradObj','on','MaxIter',100,'DerivativeCheck',der_control,...
%     'TolFun',1.e-6,'TolX',1.e-6,'DiffMinChange',1.e-5,'Display','final',...
%     'PlotFcns',@optimplotfval,'LargeScale','on');


figure()
xlabel("iteration")
ylabel("cost function")
hold on



  opt = optimset('GradObj','on','MaxIter',maxit,'TolX',1.e-6,'TolFun',1.e-6,...
                'OutputFcn', @showJ_history)
 [a1, fval,exitflag, output, grad, hess] = fminunc(@costo,a0,opt);

 
 hold off
 
 
 
 %
% 




% end

elapsed_time=cputime-t;

% save a2 a1;


% print('-depsc',filename1);

 T1 = deforma(a1,griglia);
figure(1);
subplot(2,3,5); imshow(vector2matrix(T1,Li));title('Transformed template image');

subplot(2,3,6)
disp_deformazione(a1,griglia);title('Transformation')
 
 S=zeros(2^j,2^j,3);
 % S(:,:,1)=matrix2vector(R,Li);
 S(:,:,1) = Rclean;
 S(:,:,2)=vector2matrix(T,Li);
 subplot(2,3,3); imshow(S);title('Reference vs Template')

 T1 = min(T1,1); T1 = max(T1,0);
 S(:,:,2)=vector2matrix(T1,Li);
  subplot(2,3,4); imshow(S);title('Reference vs transformed Template');

  
  % print('-depsc',filename3);


output


disp(['CPU-time: ',num2str(elapsed_time)]);

% disp(['Costo least square = ',num2str(costoLS(a1))]);
% disp(['Costo least square normalizzato = ',num2str(costoLS(a1))]);
% disp(['Costo SSIM (p=1) = ',num2str(costossim(a1,1.01))]);
% disp(['Costo SSIM (p=1.01) = ',num2str(costossim(a1,1))]);
% disp(['Costo SSIM (p=1.5) = ',num2str(costossim(a1,1.5))]);
% disp(['Costo SSIM (p=2) = ',num2str(costossim(a1,2))]);
% disp(['Costo SSIM (p=3) = ',num2str(costossim(a1,3))]);
% disp(['Costo SSIM (p=10) = ',num2str(costossim(a1,10))]);
% disp(['Costo HVS = ',num2str(costoHVS(a1))]);
% disp(['Costo Besov = ',num2str(costoBesov(a1,besov_q))]);
% disp(['Costo MI = ',num2str(costoMI2(a1))]);

diary off;
clear hvs

#{
save(filename5,'a1','T1');

[y, Fs, nbits, opts] = wavread('small-bell-ring-01.wav');
sound(y,Fs)
#}
