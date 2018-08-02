function Dphi = gradphi(griglia)
global spazio Mass

% ATTENZIONE: assumiamo che phi sia lineare in a, quindi gradphi non
% dipende da a
% UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Dphi(i,k)=D(phi^k)/Dai

N=2*spazio.npoints;
% x = griglia.x; y=griglia.y;

Dphi = zeros(griglia.npoints,N,2);

    Dphi(:,1:N/2,1)=Mass;
    Dphi(:,N/2+1:N,2)=Mass;

end

