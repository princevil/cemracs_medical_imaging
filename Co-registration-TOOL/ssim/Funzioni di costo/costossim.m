function [J,DJ,HJ] = costo(a,p)
global griglia R


%% Costo SSIM

[J1,DJ1,HJ]=costossimd1(a);
[J2,DJ2,HJ]=costossimd2(a);
Jp = J1^p+J2^p;
J = Jp^(1/p);
DJ = Jp^(1/p-1)*p*(J1^(p-1)*DJ1+J2^(p-1)*DJ2)/p;




end

