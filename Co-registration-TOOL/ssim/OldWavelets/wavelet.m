function ys=wavelet(id,a,jmas)

nw=max(size(a)); L=2*nw-1;
v = valori(a,id)
ys=zeros(2**jmas*L,1)

for j=0:jmas-1
	ys=refine(ys,a,id)
end
	