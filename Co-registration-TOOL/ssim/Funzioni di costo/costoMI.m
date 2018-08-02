function [J,HJ,DJ] = costoMI(a)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global R griglia
global Nsample Kmi
% Nsample passo di campionamento dell'insieme dei valori assunti

npix = length(R);

N = length(a);

da = 1/Nsample;
gamma = Kmi * da;

Ta = deforma(a,griglia);
gradTa = gradiente(a,griglia);


Ta = Ta(1:npix);
Ra = R(1:npix);




% DhT = zeros(N,Nsample);



% Dh_joint = -2*Dh_joint/(npix*gamma);
% DhT = -2*DhT/(npix*gamma);

% DhT = ones(Nsample,1)*DhT;

% for j = 1:N
% DhT2(:,:,j) = ones(Nsample,1)*DhT(j,:);
% end

[h_joint,hR,hT]=buildHist1(Ra,Ta,gradTa);
% [h_check,hR_c,hT_c] = buildHist2(Ra,Ta);


den=hR'*hT;





hT = ones(Nsample,1)*hT;

DhT = zeros(Nsample^2,N);


den = reshape(den,Nsample^2,1);
hT = reshape(hT,Nsample^2,1);



% Dhj = zeros(Nsample^2,N);
% for j = 1:N
% Dhj(:,j)=reshape(Dh_joint(:,:,j),Nsample^2,1);    
% DhT(:,j) = reshape(DhT2(:,:,j),Nsample^2,1);
% end
%   
% Dh_joint = Dhj;

uni = ones(Nsample^2,1);

h_trunc = h_joint;

iz = (h_trunc<= 1.e-16);
h_trunc(iz)=uni(iz);
den(iz) = uni(iz);

% [norm(h_joint) norm(h_trunc) norm(den)]

J = -sum(h_joint.*log(h_trunc./den))/(Kmi^2);
% J = hT;
% J = h_joint;

% for j = 1:N
% DJ(j) = sum(Dh_joint(:,j).*log(h_trunc./den - 1/log(2))+h_joint.*DhT(:,j)./hT);
% end

DJ=[];
HJ = [];

end


function w = pwindow(x,gamma)
w = exp(-(x/gamma).^2);
end