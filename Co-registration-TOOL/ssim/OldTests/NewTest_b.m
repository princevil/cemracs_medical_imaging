clear all
global spazio spazio_im griglia T R Xi Yi Ti Dxi Dyi Li Mass jmax AIbase
global interp_type cost_function

global hvs

nrefine=2;
interp_type = 'AI';
cost_function = 'SSIM2'
opt_algorithm = 'QuasiNewton';
der_control = 'off';
% immagine
j = 7;
nome_immagine = 'africasculpt';
% nome_immagine = 'facet';

% AI wavelet per la descrizione dell'immagine
D = 6;

% Trasformazioni
nw = 3; j0 = 2; jwi = 2;

disp(['Interpolation : ',interp_type]);
disp(['Cost function : ',cost_function]);

directory = ['Tests/',interp_type,'-',cost_function]
mkdir(directory);
nome_immagine = 'africasculpt';
% nome_immagine = 'facet';

stringa = datestr(now,30)
stringa = [stringa,'-',];

filename1 = [directory,'/',stringa,'-convhist1'];
filename2 = [directory,'/',stringa,'-convhist2'];
filename3 = [directory,'/',stringa,'-result'];
filename4 = [directory,'/',stringa,'-diary'];


% diary(filename4);

addpath('C:\Users\Silvia\Dropbox\bspline_tools_1_2\'); 

figure(1); clf
%jmax: risoluzione con cui si valuta PHI


% Inizializzazione dello spazio delle trasformazioni
jmax=9;
disp(['Trasformazione: wavelet interpolanti - nw = ',num2str(nw),' - j0 = ',num2str(j0),...
    ' - J = ',num2str(jwi)]);

base=start(nw,jmax);
spazio = uniform2d(j0,jwi); % "trasformazioni"


AIbase=AIstart(D,jmax);

% griglia su cui vive l'immagine
griglia = quadgrid(j); % "pixel"
h = 1/2.^j;

nome_template = ['Images/',nome_immagine,num2str(2^j),'.jpg']; 
nome_reference = ['Images/',nome_immagine,num2str(2^j),'_T.jpg']; 


disp(['Immagine = ',nome_immagine,num2str(2^j)]);
R = imread(nome_reference);
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


if(strcmp(interp_type,'Spline'))
% Costruzione dei dati per l'interpolazione

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


% disp('Fine interpolazioni'); pause


figure(1)
subplot(2,3,1); imshow(R); title('Reference image');
subplot(2,3,2); imshow(T); title('Template image');




T = matrix2vector(T,Li);
R = matrix2vector(R,Li);
Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base);

disp('costruito operatore di massa');

% th=.3;
% a0 = [0; cos(th)-1; -sin(th); cos(th)-1-sin(th);...
%   -.2; sin(th)-.2;cos(th)-1.2; sin(th)+cos(th)-1.2] +.1*rand(8,1);
a0 = zeros(2*spazio.npoints,1);

costo0 = costo(a0);
t = cputime;
switch opt_algorithm

    case 'QuasiNewton'
        
        for extiter=1:100
options=optimset('GradObj','on',... %'HessUpdate','steepdesc',
    'MaxIter',5,'DerivativeCheck',der_control,...
     'TolFun',.00001,'TolX',1.e-5,...  %'DiffMinChange',1.e-4,
    'Display','final','PlotFcns',@optimplotfval,...
     'LargeScale','off');
% % options=optimset('GradObj','off','MaxFunEvals',1000,'DerivativeCheck','on')
 [a1,fval,exitflag,output] = fminunc(@costo,a0,options);
 err = costo(a1)/costo0;
figure(3)
subplot(1,2,1)
disp_deformazione(a1,griglia);title('Transformation')
 
T1 = deforma(a1,griglia);

 S=zeros(2^j,2^j,3);
 S(:,:,1)=vector2matrix(R,Li);
 S(:,:,2)=vector2matrix(T1,Li);
 subplot(1,2,2); imshow(S);
 
 disp(['Iterazioni: ',num2str(extiter*5),' - Diminuzione errore: ',num2str(err)]);
 pause;
 
 a0=a1;
        end
% grad 
    otherwise
 options=optimset('GradObj','on','MaxIter',100,'DerivativeCheck',der_control,...
     'TolFun',1.e-6,'TolX',1.e-6,'DiffMinChange',1.e-5,'Display','final',...
     'PlotFcns',@optimplotfval,'LargeScale','on');
 [a1,fval,exitflag,output] = fminunc(@costo,a0,options);

end

elapsed_time=cputime-t;

 print('-depsc',filename1);
 T1 = deforma(a1,griglia);
figure(1);
subplot(2,3,5); imshow(vector2matrix(T1,Li));title('Transformed template image');

subplot(2,3,6)
disp_deformazione(a1,griglia);title('Transformation')
 
 S=zeros(2^j,2^j,3);
 S(:,:,1)=vector2matrix(R,Li);
 S(:,:,2)=vector2matrix(T,Li);
 subplot(2,3,3); imshow(S);title('Reference vs Template')

 T1 = min(T1,1); T1 = max(T1,0);
 S(:,:,2)=vector2matrix(T1,Li);
  subplot(2,3,4); imshow(S);title('Reference vs transformed Template');
print('-depsc',filename3);


output


disp(['CPU-time: ',num2str(elapsed_time)]);

disp(['Costo least square = ',num2str(costoLS(a1))]);
disp(['Costo least square normalizzato = ',num2str(costoLS(a1))]);
disp(['Costo SSIM (p=1) = ',num2str(costossim(a1,1.01))]);
disp(['Costo SSIM (p=1.01) = ',num2str(costossim(a1,1))]);
disp(['Costo SSIM (p=1.5) = ',num2str(costossim(a1,1.5))]);
disp(['Costo SSIM (p=2) = ',num2str(costossim(a1,2))]);
disp(['Costo SSIM (p=3) = ',num2str(costossim(a1,3))]);
disp(['Costo SSIM (p=10) = ',num2str(costossim(a1,10))]);
disp(['Costo HVS = ',num2str(costoHVS(a1))]);

diary off;
clear hvs

[y, Fs, nbits, opts] = wavread('small-bell-ring-01.wav');
sound(y,Fs);

