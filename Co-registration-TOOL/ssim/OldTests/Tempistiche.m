clear all
global spazio spazio_im griglia T R Xi Yi Ti Dxi Dyi Li Mass jmax AIbase
global interp_type cost_function
global wname maxlev% wavelet da usare per il calcolo della norma Besov.
global hvs
global besov_q;
global Nsample Kmi;

startmode = 'zero';
% startmode = 'multiscale';

dwtmode('per')
wname = 'haar';

% immagine
j = 9
nome_immagine = 'africasculpt';
% nome_immagine = 'facet';

nrefine=3;

interp_type = 'AI';
% interp_type = 'Cubic';
%interp_type = 'BSplineP';

cost_function = 'RBesov';
besov_q = 2;
Kmi=3; Nsample = 32;
maxit=800;

opt_algorithm = 'TrustRegion';
der_control = 'off';
% noise_type = 'gaussian';
noise_type = 'none';

maxlev=j;

% AI wavelet per la descrizione dell'immagine
D = 6;

% Trasformazioni
% nw=1; j0=0; j1=0;  % Q1 tranformation

nw = 3; j0 = 2; jwi = 2;

if(strcmp(startmode,'multiscale'))
load a1;
a0=a1;
else
a0 = zeros(2*(2^jwi+1)^2,1);
end


directory = ['Tests/',interp_type,num2str(nrefine),'-',cost_function];
if(strcmp(cost_function,'Besov'))
    directory = [directory,num2str(besov_q)];
end
directory=[directory,'-',noise_type];

mkdir(directory);
nome_immagine = 'africasculpt';
% nome_immagine = 'facet';

stringa = datestr(now,30)
stringa = [stringa,'-',num2str(j)];

filename1 = [directory,'/',stringa,'-convhist1'];
filename2 = [directory,'/',stringa,'-convhist2'];
filename3 = [directory,'/',stringa,'-result'];
filename4 = [directory,'/',stringa,'-diary.txt'];
filename5 = [directory,'/',stringa,'-data.mat'];

% diary(filename4);

disp(['Interpolation : ',interp_type,' - nrefine = ',num2str(nrefine)]);
disp(['Cost function : ',cost_function]);


addpath('C:\Users\Silvia\Dropbox\bspline_tools_1_2\'); 

% figure(1); clf
%jmax: risoluzione con cui si valuta PHI




% Inizializzazione dello spazio delle trasformazioni
jmax=9;
disp(['Trasformazione: wavelet interpolanti - nw = ',num2str(nw),' - j0 = ',num2str(j0),...
    ' - J = ',num2str(jwi)]);
if(strcmp(cost_function,'MI'))
    disp(['K = ',num2str(Kmi),' - Nsample = ',num2str(Nsample)]);
end

base=start(nw,jmax);
spazio = uniform2d(j0,jwi); % "trasformazioni"


AIbase=AIstart(D,jmax);

% griglia su cui vive l'immagine
griglia = quadgrid(j); % "pixel"
h = 1/2.^j;

nome_template = ['Images/',nome_immagine,num2str(2^j),'.jpg']; 
nome_reference = ['Images/',nome_immagine,num2str(2^j),'_T.jpg']; 




%% COSTRUZIONE DEL RUMORE
switch noise_type
    case 'gaussian'
R = imnoise(R,'gaussian',0,0.1);
    case 'saltpepper'
R = imnoise(R,'salt & pepper',0.2);
    otherwise
end

%% INIZIALIZZAZIONE DELL'IMMAGINE
disp(['Immagine = ',nome_immagine,num2str(2^j)]);
R = imread(nome_reference);

Rclean = double(R)/256;
T = imread(nome_template);

R = double(R)/256;T = double(T)/256;




% Dati per il passaggio di T da matrice a vettore;
% questo e' un' escamotage, sicuramente si puo' fare in altro modo

% matrix2vector(T,Li)=reshape(T',Np,Np); 
% vector2matrix=reshape(T,Np^2,1)';
% (Np = nro di punti in ciascuna delle 2 direzioni


xt=(h/2:h:1-h/2);
yt=(h/2:h:1-h/2);
[Xt,Yt]=meshgrid(xt,yt);
Li = griddata(griglia.x,griglia.y,(1:griglia.npoints)',Xt,Yt);

N = 2^j;
% Xi = Xt; Yi = Yt; Ti = T;


if(strcmp(interp_type,'Spline')|strcmp(interp_type,'Cubic'))
%% Costruzione dei dati per l'interpolazione Spline o Bicubica

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


if (strcmp(interp_type,'AI'))
%% Costruzione dei dati per l'interpolazione AI   
    AIspace = uniformAIspace2d(j,D); %questo � lo spazio che rappresenta l'immagine con l'estensione periodica

% Dati per il passaggio di T da matrice a vettore;
% questo e' un' escamotage, sicuramente si puo' fare in altro modo


% Xi = Xt; Yi = Yt; Ti = T;


% Costruzione dei dati per la costruzione della funzione di costo e del gradiente.
% Estensione periodica di T

Te = [T(:,N-D+1:N), T, T(:,1:D)];
Te = [Te(N-D+1:N,:); Te; Te(1:D,:)];

Te = Te';

AIspace1d = uniformAIspace1d(j,D);
cgrid1d = uniform1d(j+nrefine);
[A,DA] = AIoperator1d(AIspace1d,cgrid1d,AIbase);

Ti = A*Te'*A';
Dyi = DA*Te'*A';
Dxi = A*Te'*DA';

% Te � il vettore in AIspace che corrisponde a T

cgrid = uniform2d(j+nrefine,j+nrefine);

%[Ti,Dxi,Dyi] = applyAIoperator2d(Te,AIspace,cgrid,AIbase);
Xi = reshape(cgrid.x,2^(j+nrefine)+1,2^(j+nrefine)+1)';
Yi = reshape(cgrid.y,2^(j+nrefine)+1,2^(j+nrefine)+1)';
%Ti = reshape(Ti,2^(j+nrefine)+1,2^(j+nrefine)+1)';
%Dxi = reshape(Dxi,2^(j+nrefine)+1,2^(j+nrefine)+1)';
%Dyi = reshape(Dyi,2^(j+nrefine)+1,2^(j+nrefine)+1)';

end    

if(strcmp(interp_type,'BSplineP'))
%% Costruzione dei dati per l'interpolazione BSpline Periodica
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

% disp('Fine interpolazioni'); pause

% 
% figure(1)
% subplot(2,3,1); imshow(R); title('Reference image');
% subplot(2,3,2); imshow(T); title('Template image');




T = matrix2vector(T,Li);
R = matrix2vector(R,Li);
Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base);

disp('costruito operatore di massa');

% th=.3;
% a0 = [0; cos(th)-1; -sin(th); cos(th)-1-sin(th);...
%   -.2; sin(th)-.2;cos(th)-1.2; sin(th)+cos(th)-1.2] +.1*rand(8,1);

a0 = rand(2*(2^jwi+1)^2,1);

t = cputime;
costoLS(a0); cLS = cputime - t;
disp(['Costo LS = ',num2str(cputime - t)]);

t = cputime;
costoRBesov(a0); c = cputime - t;
 disp(['CPU GSSIM = ',num2str(cputime - t),...
     ' (',num2str(c/cLS),' time the LS CPU)']);
% 
% 
% t = cputime;
% costoHVS(a0); c = cputime-t;
% disp(['CPU HVS = ',num2str(cputime - t),...
%     ' (',num2str(c/cLS),' time the LS CPU']);
% 
t = cputime;
 costossim(a0,2); c = cputime-t;
 disp(['CPU SSIM = ',num2str(cputime - t),...
     ' (',num2str(c/cLS),' time the LS CPU)']);
% 
 t = cputime;
 costoBesov(a0); c = cputime-t;
 disp(['CPU Besov = ',num2str(cputime - t),...
     ' (',num2str(c/cLS),' time the LS CPU)']);
% 
Ta = deforma(a0,griglia);
gradTa = gradiente(a0,griglia);

 t = cputime;
[h_joint,Dh_joint,hT,DhT,hR]=hist1(Ta,R,gradTa); c=cputime-t;
disp(['CPU HIST = ',num2str(cputime - t),...
     ' (',num2str(c/cLS),' time the LS CPU']);


 
 t = cputime;
 costoMI(a0); c = cputime-t;
 disp(['CPU MI = ',num2str(cputime - t),...
     ' (',num2str(c/cLS),' time the LS CPU)']);

