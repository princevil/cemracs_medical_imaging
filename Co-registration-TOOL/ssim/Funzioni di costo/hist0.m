function [h_joint,Dh_joint,hT,DhT,hR] = hist0(Ta,Ra,gradTa)

global griglia
global Nsample Kmi
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



N = size(gradTa,2); % N numero di parametri della trasformazione
npix = length(Ta); % numero di pixel nell'immagine

da = 1./Nsample; % passo di campionamento dei livelli di grigio

gamma = da*Kmi; %  epsilon

L = 6; % [-L,L] supporto effettivo della finestra di Parzen


hR = zeros(Nsample,1);
hT = zeros(1,Nsample);
DhT = zeros(N,Nsample);

D_check = zeros(Nsample^2,N);
h_joint = zeros(Nsample^2,1);
h_check = zeros(Nsample^2,1);
Dh_joint = zeros(Nsample^2,N);


amin = 1; amax=Nsample; Na=Nsample;
bmin = 1; bmax=Nsample; Nb=Nsample;
    
x = griglia.x;
y = griglia.y;

for ib = 1:Nsample
    
    b = (ib-.5)*da;

    hT(ib) = sum(pwindow(Ta - b,gamma))/npix;  
    hR(ib) = sum(pwindow(Ra - b,gamma))/npix;
    
    DhT(:,ib) = gradTa'*pwindowprime(Ta - b,gamma)/npix;

    for ia = 1:Nsample
        a = (ia-.5)*da;
        h_joint((ib-1)*Nsample+ia) = sum(pwindow(Ra - a,gamma).*pwindow(Ta - b,gamma))/npix;
        
        Dh_joint((ib - 1)*Nsample+ia,:) = (pwindow(Ra - a,gamma).*pwindowprime(Ta - b,gamma))'*gradTa/npix;
%         Dh_joint((ib - 1)*Nsample+ia,1)=sum(pwindow(Ra - a,gamma).*pwindowprime(Ta - b,gamma).*gradTa(:,1))/npix; 
%         Dh_joint((ib - 1)*Nsample+ia,2)=sum(pwindow(Ra - a,gamma).*pwindowprime(Ta - b,gamma).*gradTa(:,2))/npix; 
        
    end
    
end

% 
hT = repmat(hT,Nsample,1); hT = reshape(hT,Nsample^2,1);
hR = repmat(hR,1,Nsample); hR = reshape(hR,Nsample^2,1);

ib = repmat((1:Nsample),Nsample,1);
DhT = DhT';
DhT = DhT(ib,:);

end


function w = pwindow(x,gamma)
w = exp(-(x/gamma).^2);
% w = sin(gamma*x.^2);
% w = sin(x);
end

function wx = pwindowprime(x,gamma);
[n,m]=size(x);
wx = -2*x.*exp(-(x*gamma).^2)/(gamma^2);
% wx=cos(x);
% wx = gamma*2*x.*cos(gamma*x.^2);
end