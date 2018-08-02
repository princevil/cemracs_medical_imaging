function hessTa = hessiano(a,griglia)
gradTa = zeros(griglia.npoints,2);

[hatx,haty]=phi(griglia,a);

N = max(size(a));
Dphi = gradphi(griglia);
D2phi = hessphi(griglia);

[Tx,Ty]=DT(hatx,haty);
[Txx,Tyy,Txy]=D2T(hatx,haty);

hessTa = zeros(griglia.npoints,N,N);

for i=1:N
    for j=1:N
        hessTa(:,j,i) = (Txx.*Dphi(:,j,1)+Txy.*Dphi(:,j,2)).*Dphi(:,i,1)+ ...
         (Txy.*Dphi(:,j,1)+Tyy.*Dphi(:,j,2)).*Dphi(:,i,2) + ...
         Tx.*D2phi(:,i,j,1) + Ty.*D2phi(:,i,j,2);
    end
end

%gradTa = [Tx,Ty]*Dphi;
