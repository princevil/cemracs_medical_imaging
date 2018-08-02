function I = mi2(A,B) 

L = 256;
%A = double(A);  

%C = transform2(B,p');
%C = warp_affine_transf(B,p);

% figure(1)
% subplot(1,2,1); imshow(A,[]);
% subplot(1,2,2); imshow(C,[]);

na = hist(A(:),L); 
na = na/sum(na);

nb = hist(B(:),L); 
%nnb = conv2(nb,h);
nb = nb/sum(nb);

n2 = histogram2(A,B,L);
%nn2 = conv2(n2,h);
n2 = n2/sum(n2(:));

I = -sum(minf(n2,na'*nb));
%I = conv2(II,h);

end

function n=histogram2(A,B,L) 
%histogram2 calcola l'istogramma congiunto di due immagini o segnali
%
%   n=histogram2(A,B,L) è l'istogramma congiunto delle immagini A and B, 
%     (L bins per ciascuna immagine)

ma=min(A(:)); 
MA=max(A(:)); 
mb=min(B(:)); 
MB=max(B(:));

% For sensorimotor variables, in [-pi,pi] 
% ma=-pi; 
% MA=pi; 
% mb=-pi; 
% MB=pi;

% Scale and round to fit in {0,...,L-1} 
A=round((A-ma)*(L-1)/(MA-ma+eps)); 
B=round((B-mb)*(L-1)/(MB-mb+eps)); 
n=zeros(L); 
x=0:L-1; 
for i=0:L-1 
    n(i+1,:) = histc(B(A==i),x,1); 
end
end


function y=minf(pab,papb)

I = find(papb(:)>1e-12 & pab(:)>1e-12); % supporto funzione 
y = pab(I).*log2(pab(I)./papb(I));
end
 
