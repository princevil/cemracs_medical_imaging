function [J,DJ,HJ] = costo(a)
global griglia R
global cost_function

 % cost_function

switch cost_function
    case 'WNRMSE'   % Questa e quella dell'articolo
        [J,DJ,HJ] = costoWNRMSE(a);
    case 'MIR'
        [J,DJ,HJ] = costoMIR(a);
    case 'MI'
        [J,DJ,HJ] = costoMI2(a);
    case 'Besov'
        [J,DJ,HJ] = costoBesov(a);
    case 'HVS'
        [J,DJ,HJ] = costoHVS(a);
    case 'SSIM1e1'
        [J,DJ,HJ] = costossim(a,1.01);
    case 'SSIM1e5'
        [J,DJ,HJ] = costossim(a,1.5);
    case 'SSIM1'
[J,DJ,HJ] = costossim(a,1);
    case 'SSIM2'
[J,DJ,HJ] = costossim(a,2);
    case 'SSIM3'
[J,DJ,HJ] = costossim(a,3);
    case 'SSIM10'
        [J,DJ,HJ] = costossim(a,10);
    case 'SSIM100'
        [J,DJ,HJ] = costossim(a,100);
    case 'normalizedLS'
[J,DJ,HJ]=costoLSnormalizzato(a);       
    otherwise
[J,DJ,HJ]=costoLS(a);
end

% [J,DJ,HJ]=costoLSnormalizzato(a);


end

