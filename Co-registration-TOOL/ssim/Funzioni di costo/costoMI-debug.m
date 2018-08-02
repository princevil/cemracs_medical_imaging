function [J,HJ,DJ] = costoMI-debug(a)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global R griglia
global Nsample %Kmi
% Nsample passo di campionamento dell'insieme dei valori assunti

disp('Pippo')
L = 1; %(-L,L) = supporto effettivo della gaussiana;
Kmi = 1;

da = 1/Nsample
gamma = Kmi * da;

%Ta = deforma(a,griglia);
%gradTa = gradiente(a,griglia);


hR = zeros(1,Nsample);
hT = zeros(1,Nsample);

h_joint = zeros(Nsample,Nsample);

for i = 1:1
    r = .3;
    t = .027;
    
    amin = max(ceil(r/da+.5)-L*Kmi,1);
    amax = min(floor(r/da+.5)+L*Kmi,Nsample);
    
    bmin = max(ceil(t/da+.5)-L*Kmi,1);
    bmax = min(floor(t/da+.5)+L*Kmi,Nsample);
  
    
    [amin amax bmin bmax]
    
    v = pwindow(r-((amin:amax)-.5)*da,gamma);
    w = pwindow(t-((bmin:bmax)-.5)*da,gamma);
   
     
    v
    
    w
    
    Hx = v'*w; 
    
    hR(amin:amax) = hR(amin:amax)+v;
    hT(bmin:bmax) = hT(bmin:bmax)+w;
    
    h_joint(amin:amax,bmin:bmax) = h_joint(amin:amax,bmin:bmax) + Hx;
       
   
end

den=hR'*hT;

h_joint = reshape(h_joint,Nsample^2,1);
den = reshape(den,Nsample^2,1);
uni = ones(Nsample^2,1);



iz = (h_joint<= 1.e-16);
h_joint(iz)=uni(iz);
den(iz) = uni(iz);

J = -sum(h_joint.*log(h_joint./den))/(Nsample^2);

DJ = [];
HJ = [];

end


function w = pwindow(x,gamma)
w = exp(-(x/gamma).^2);
end