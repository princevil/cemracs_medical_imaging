function base=start(nw,J)
m=nw;
cm=4; for i=2*m-1:-1:m, cm=cm*i/4; end
cm=cm^2;
a = zeros(m,1);

for n=1:m
	aa=(-1)^(n+1)*cm/(2*n-1);
	for i=m-n:-1:2, aa=aa/i; end
	for i=m+n-1:-1:2, aa=aa/i; end
	a(n)=aa/2;
end

L=2*nw-1;
P=L;
J0=ceil(log2(L));

if(J<J0), J=J0; end; 

THETA=[refine(a,0,J) refine(a,1,J) refine(a,2,J)];

base.a = a;
base.THETA = THETA;
base.J=J;
base.L=L;
base.P=P;
base.J0=J0;
