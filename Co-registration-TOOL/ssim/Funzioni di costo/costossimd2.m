function [J,DJ,HJ] = costossimd2(a)
global griglia R


HJ =[];
%% Costo SSIM d_2

Ta = deforma(a,griglia);
gradTa = gradiente(a,griglia);
% hessTa = hessiano(a,griglia);
h2 = 1/griglia.npoints;
epsilon = 1;

chi = ones(size(Ta));


Tabar = Ta'*chi*h2;
Rbar = R'*chi*h2;


numeratore = (Ta - R)'*(Ta - R)*h2 - (Tabar - Rbar)^2;
denominatore = Ta'*Ta*h2 - Tabar^2 + R'*R*h2 - Rbar^2 + epsilon;
J = sqrt(numeratore/denominatore);

% J = .5*(Ta-R)'*(Ta-R)/griglia.npoints;
N=max(size(a)); DJ = zeros(N,1);

for j = 1:N,
    
    
            CX = (2*denominatore-2*numeratore)/(denominatore^2);
            Cchi = (2*Tabar*numeratore - 2*(Tabar-Rbar)*denominatore)/(denominatore^2);
            CR = -2/denominatore;
            d = gradTa(:,j);
            DJ(j) = CX*Ta'*d*h2 + Cchi*chi'*d*h2 + CR*R'*d*h2;
            DJ(j) = DJ(j)/(2*J);
       
%         C1 = (epsilon + 2*Ta'*R*h2)/(denominatore^2);
%         C2 = 1/denominatore;
%         DJ(j) =(C1*Ta - C2*R)'*gradTa(:,j)*h2;
               
%         for k = 1:N
%            % Hessiano ridotto
%            HJ(j,k) = gradTa(:,j)'*gradTa(:,k)/griglia.npoints;
%             % Vero Hessiano
%             % HJ(j,k) = gradTa(:,j)'*gradTa(:,k) + (Ta - R)'*hessTa(:,j,k);
% %         end
%         end


end

