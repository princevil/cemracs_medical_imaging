function  [h_joint,hR,hT] = buildHist1(Ra,Ta,gradTa)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global Nsample  Kmi

N = size(gradTa,2);
npix = length(Ta);

L = 4; %(-L,L) = supporto effettivo della gaussiana;

h_joint = zeros(Nsample,Nsample);


hR = zeros(1,Nsample);
hT = zeros(1,Nsample);

da = 1./Nsample;
gamma=Kmi*da;

Dh_joint = zeros(Nsample,Nsample,N);

%npix = griglia.npoints;

for i = 1:npix
    r = Ra(i);
    t = Ta(i);
    
    amin = max(ceil(r/da+.5)-L*Kmi,1);
    amax = min(floor(r/da+.5)+L*Kmi,Nsample);
    
    bmin = max(ceil(t/da+.5)-L*Kmi,1);
    bmax = min(floor(t/da+.5)+L*Kmi,Nsample);
  
    b = t-((bmin:bmax)-.5)*da;
    v = pwindow(r-((amin:amax)-.5)*da,gamma);
    w = pwindow(b,gamma);

    wprime = w.*b; 
    

  Hx = v'*w;
 
% Hx
%   pause
    hR(amin:amax) = hR(amin:amax)+v;
    hT(bmin:bmax) = hT(bmin:bmax)+w;
    
   
 h_joint(amin:amax,bmin:bmax) = h_joint(amin:amax,bmin:bmax) + Hx;
% pause   
         Dhx = v'*wprime;
         for j = 1:N
             g = gradTa(i,j);
 %            DhT(j,bmin:bmax)=DhT(j,bmin:bmax)+g*wprime;
             Dh_joint(amin:amax,bmin:bmax,j) = Dh_joint(amin:amax,bmin:bmax,j)+g*Dhx;
         end
         
end


h_joint = h_joint/npix;


hR = hR/npix;
hT = hT/npix;

h_joint = reshape(h_joint,Nsample^2,1);

end


function w = pwindow(x,gamma)
w = exp(-(x/gamma).^2);
end
