function [J,DJ,HJ] = costoMI3(a)
% global npix
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global R griglia
global Nsample Kmi
global maxlev wname
global livello
% Nsample passo di campionamento dell'insieme dei valori assunti



Np = sqrt(griglia.npoints);

L = 6;%(-L,L) = supporto effettivo della gaussiana;

N = length(a);
npix = length(R);

da = 1/Nsample;
gamma = Kmi * da;

Ta = deforma(a,griglia);
gradTa = gradiente(a,griglia);
Ra = R;

Ta = reshape(Ta,Np,Np)'; 
Ta=wavedec2(Ta,maxlev,wname)';
Ra = reshape(R,Np,Np)'; 
Ra = wavedec2(Ra,maxlev,wname)';

for i = 1:N;
    gradTaa = reshape(gradTa(:,i),Np,Np)'; 
      gradTaa=wavedec2(gradTaa,maxlev,wname)';
      gradTa(:,i)=(soglia(Ta)+dsoglia(Ta).*Ta).*gradTaa;
end

Ta = soglia(Ta).*Ta;
Ra = soglia(Ra).*Ra;


% Massimo = max(max(Ta),max(Ra));
% Minimo = min(min(Ta),min(Ra));
% 
% Ta = (Ta-Minimo)/(Massimo-Minimo);
% Ra = (Ra - Minimo)/(Massimo-Minimo);
% gradTa=gradTa/(Massimo-Minimo);

% [h_joint,Dh_joint,hT,DhT,hR]=buildHist2(Ta,Ra,gradTa);


[h_joint,Dh_joint,hT,DhT,hR]=hist1new(Ta,Ra,gradTa);

Nsample = sqrt(length(h_joint));

den=hR.*hT;

% calcolo dell'argomento del log

h_norm = h_joint;

iz = (h_norm<= 1.e-16);
nz = sum(iz);
h_norm(iz)=ones(nz,1);
den(iz) = ones(nz,1);
hT(iz) = ones(nz,1); % questa troncatura serve per la derivata del log

h_norm = h_norm./den;

diag1=sparse((1:Nsample^2)',(1:Nsample^2)',log(h_norm)+1);
diag2=sparse((1:Nsample^2)',(1:Nsample^2)',h_joint./hT);

J = -sum(h_joint.*log(h_norm))/(Kmi^2);
DJ = -sum(diag1*Dh_joint-diag2*DhT)/(Kmi^2);

HJ = [];

end

function s = soglia(x)
global eps1 eps2
    s = 0*x;
    l1 = (abs(x)>eps2);
    l2 = (abs(x)<=eps2)&(abs(x)>eps1);
    s(l1)=ones(size(x(l1)));
    den = (eps2-eps1);
    s(l2)= .5*cos(pi*(abs(x(l2))-eps2)/den)+.5;
end

function s = dsoglia(x)
global eps1 eps2
 global eps1 eps2
    s = 0*x;
    l2 = (abs(x)<=eps2)&(abs(x)>eps1);
    den = (eps2-eps1);
    s(l2) = -.5*pi*sin(pi*(abs(x(l2))-eps2)/den).*sign(x(l2))/den;
end




% 
% function [h_joint,Dh_joint,hT,DhT,hR] = buildHist2(Ta,Ra,gradTa)
% global Nsample Kmi
% %UNTITLED2 Summary of this function goes here
% %   Detailed explanation goes here
% 
% 
% 
% N = size(gradTa,2);
% npix = length(Ta);
% 
% da = 1./Nsample;
% 
% gamma = da*Kmi;
% 
% L = 6;
% 
% 
% hR = zeros(Nsample,1);
% hT = zeros(1,Nsample);
% DhT = zeros(N,Nsample);
% 
% h_joint = zeros(Nsample^2,1);
% Dh_joint = zeros(Nsample^2,N);
% 
% 
% for i = 1:npix
%         
%     r = Ra(i);
%     t = Ta(i);
%     
%     % amin = max(ceil(r/da+.5)-L*Kmi,1);
%     % amax = min(floor(r/da+.5)+L*Kmi,Nsample);
%     % Na = amax-amin+1;
%     
%     amin = 1; amax=Nsample; Na=Nsample;
%    
% %     bmin = max(ceil(t/da+.5)-L*Kmi,1);
% %     bmax = min(floor(t/da+.5)+L*Kmi,Nsample);
% %     Nb = bmax-bmin+1;
% 
%     bmin = 1; bmax=Nsample; Nb=Nsample;
%     
%     
%     ia = repmat((amin:amax)',1,Nb);
%     ib = repmat((bmin:bmax),Na,1);
%     
%     a = r-(ia-.5)*da;
%     b = t-(ib-.5)*da;
%     
%     v = pwindow(a(:,1),gamma); 
%     w = pwindow(b(1,:),gamma);
%     wprime = -2*b(1,:).*w/gamma;
%     
%     hR(amin:amax) = hR(amin:amax)+v;
%     hT(bmin:bmax) = hT(bmin:bmax)+w;
%     DhT(:,bmin:bmax) = DhT(:,bmin:bmax)+gradTa(i,:)'*wprime;
%     
%     
%     v = repmat(v,1,Nb); v = reshape(v,Na*Nb,1);
%     w = repmat(w,Na,1); w = reshape(w,Na*Nb,1);
%     
%     
%     ia = reshape(ia,Na*Nb,1);
%     ib = reshape(ib,Na*Nb,1);
%     
%     
%     pointer = (ib - 1)*Nsample + ia;
%   
%  
%     a = reshape(a,Na*Nb,1);
%     b = reshape(b,Na*Nb,1);
%     
%     wprime = -2*b.*w/gamma;
%     
%      
%     Dh_joint(pointer,:) = Dh_joint(pointer,:)+(v.*wprime)*gradTa(i,:);
%     h_joint(pointer) = h_joint(pointer) + v.*w;
%  
% end
% 
%  ib = repmat((1:Nsample),Nsample,1);
%  ib = reshape(ib,Nsample^2,1);
%  
% 
% h_joint = h_joint/npix;
% hT = hT/npix;
% hR = hR/npix;
% 
% hT = repmat(hT,Nsample,1); hT = reshape(hT,Nsample^2,1);
% hR = repmat(hR,1,Nsample); hR = reshape(hR,Nsample^2,1);
% DhT = DhT';
% DhT = DhT(ib,:)/npix;
% Dh_joint = Dh_joint/npix;
% 
% end

% 
% function w = pwindow(x,gamma)
% % w = exp(-(x/gamma).^2);
% w = x;
% end