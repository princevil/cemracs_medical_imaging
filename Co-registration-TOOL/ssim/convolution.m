function c=convolution(a,b)

la=max(size(a)); lb=max(size(b));
lc=la+lb-1;

for n=1:lc
	c(n)=0;
	for k=1:la
		if(((n-k)>0)&((n-k)<=lb)), c(n)=c(n)+a(k)*b(n-k); end
	end
end