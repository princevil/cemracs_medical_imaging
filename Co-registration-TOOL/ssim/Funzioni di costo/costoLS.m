function [J,DJ,HJ] = costoLS(a)
global griglia R

HJ=[];

Ta = deforma(a,griglia);
gradTa = gradiente(a,griglia);
% hessTa = hessiano(a,griglia);


J = .5*(Ta-R)'*(Ta-R)/griglia.npoints;
N=max(size(a)); DJ = zeros(N,1);

for j = 1:N,
        DJ(j) = (Ta - R)'*gradTa(:,j)/griglia.npoints;
%         for k = 1:N
%            % Hessiano ridotto
%            HJ(j,k) = gradTa(:,j)'*gradTa(:,k)/griglia.npoints;
%             % Vero Hessiano
%             % HJ(j,k) = gradTa(:,j)'*gradTa(:,k) + (Ta - R)'*hessTa(:,j,k);
% %         end
% end


end

