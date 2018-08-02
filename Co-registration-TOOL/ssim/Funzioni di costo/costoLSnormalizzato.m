function [J,DJ,HJ] = costo(a)
global griglia R

%% Costo SSIM

HJ = [];

Ta = deforma(a,griglia);
gradTa = gradiente(a,griglia);
% hessTa = hessiano(a,griglia);
h2 = 1/griglia.npoints;
epsilon = 0.1;

normR = R'*R*h2;
normTa = Ta'*Ta*h2;



denominatore = (normR+normTa+epsilon);
J = .5*((Ta-R)'*(Ta-R)*h2)/denominatore;

% J = .5*(Ta-R)'*(Ta-R)/griglia.npoints;
N=max(size(a)); DJ = zeros(N,1);

for j = 1:N,
        j;
        (Ta - R)'*(Ta - R);
        
        C1 = (epsilon + 2*Ta'*R*h2)/(denominatore^2);
        C2 = 1/denominatore;
        DJ(j) =(C1*Ta - C2*R)'*gradTa(:,j)*h2;
        
               
%         for k = 1:N
%            % Hessiano ridotto
%            HJ(j,k) = gradTa(:,j)'*gradTa(:,k)/griglia.npoints;
%             % Vero Hessiano
%             % HJ(j,k) = gradTa(:,j)'*gradTa(:,k) + (Ta - R)'*hessTa(:,j,k);
% %         end
%         end


end

