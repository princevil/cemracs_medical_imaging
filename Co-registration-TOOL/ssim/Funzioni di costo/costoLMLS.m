function J = costoLMLS(a)
global griglia R


%% Costo SSIM



Ta = deforma(a,griglia);

J = (Ta - R)/sqrt(griglia.npoints);
% gradTa = gradiente(a,griglia);
% hessTa = hessiano(a,griglia);


% Jp = J1^p+J2^p;
% J = Jp^(1/p);
% DJ = Jp^(1/p-1)*p*(J1^(p-1)*DJ1+J2^(p-1)*DJ2)/p;




end

