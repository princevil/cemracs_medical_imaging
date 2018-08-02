function [h_joint,Dh_joint,hT,DhT,hR] = hist1(Ta,Ra,gradTa)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global griglia
global Nsample Kmi



N = size(gradTa,2); % N numero di parametri della trasformazione
npix = length(Ta); % numero di pixel nell'immagine

da = 1./Nsample; % passo di campionamento dei livelli di grigio

gamma = da*Kmi; %  epsilon

% gamma = 1;

L = 5; % [-L,L] supporto effettivo della finestra di Parzen


hR = zeros(Nsample,1);
hT = zeros(1,Nsample);
DhT = zeros(N,Nsample);
h_joint = zeros(Nsample^2,1);
Dh_joint = zeros(Nsample^2,N);

for pix = 1:npix
   
    r = Ra(pix);
    t = Ta(pix);
    
    amin = max(ceil(r/da+.5)-L*Kmi,1);
    amax = min(floor(r/da+.5)+L*Kmi,Nsample);
    Na = amax-amin+1;
    bmin = max(ceil(t/da+.5)-L*Kmi,1);
    bmax = min(floor(t/da+.5)+L*Kmi,Nsample);
    Nb = bmax-bmin+1;

%      amin = 1; amax = Nsample; Na = Nsample;
%      bmin = 1; bmax = Nsample; Nb = Nsample;
    
    ia = (amin:amax)';
    ib = (bmin:bmax);
    
    a = (ia - .5)*da; b = (ib - .5)*da;
    
    v = pwindow(r - a,gamma); w = pwindow(t - b,gamma);
     wprime = pwindowprime(t - b,gamma);    
     hR(amin:amax)=hR(amin:amax)+v; 
    hT(bmin:bmax)=hT(bmin:bmax)+w;
    DhT(:,bmin:bmax) = DhT(:,bmin:bmax)+gradTa(pix,:)'*wprime;
    
    v = repmat(v,1,Nb); w = repmat(w,Na,1);
    v = reshape(v,Na*Nb,1); w = reshape(w,Na*Nb,1);
    ia = repmat(ia,1,Nb); ib = repmat(ib,Na,1);
    
    pointer = (ib-1)*Nsample + ia;
    pointer = reshape(pointer,Na*Nb,1);
    
   
    wprime = repmat(wprime,Na,1);
    wprime = reshape(wprime,Na*Nb,1);
    
    h_joint(pointer) = h_joint(pointer)+v.*w; 
    Dh_joint(pointer,:) = Dh_joint(pointer,:) + (v.*wprime)*gradTa(pix,:);
    
end

h_joint=h_joint/npix;
Dh_joint=Dh_joint/npix;
hT = hT/npix;
DhT = DhT/npix;
hR = hR/npix;

hT = repmat(hT,Nsample,1); hT = reshape(hT,Nsample^2,1);
hR = repmat(hR,1,Nsample); hR = reshape(hR,Nsample^2,1);

ib = repmat((1:Nsample),Nsample,1);
DhT = DhT';
DhT = DhT(ib,:);
end



function w = pwindow(x,gamma)
w = exp(-(x/gamma).^2);
% w = x;
% w = sin(gamma*x.^2);
% w = sin(x);
end

function wx = pwindowprime(x,gamma);
[n,m]=size(x);
wx = -2*x.*exp(-(x/gamma).^2)/(gamma^2);
% wx = ones(n,m);
% wx=cos(x);
% wx = gamma*2*x.*cos(gamma*x.^2);
end
