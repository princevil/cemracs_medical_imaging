function v=valori(a,id)
nw = max(size(a)); l=2*nw-1;
if(id==0), v=zeros(2*l-1,1);v(l)=1; 
else
	fs=2^id;
	am = zeros(2*l,2*l-1);
	b=zeros(2*l,1);
	v=zeros(l,1);
	for il=-l+1:l-1
		if((2*il>-l)&(2*il<l)), am(il+l,2*il+l)=fs; end
		for k=1:nw
			i1=2*il-2*k+1; i2=2*il+2*k-1;
			if((i1>-l)&(i1<l)), am(il+l,i1+l)=fs*a(k); end
			if((i2>-l)&(i2<l)), am(il+l,i2+l)=fs*a(k); end
		end
	end
	
	for il=-l+1:l-1
		am(2*l,il+l)=il^id;
	end
	
	for il=1:2*l-1,
		am(il,il)=am(il,il)-1;
	end

	
	
	b(2*l)=factorial(id)*(-1)^id;
	
	v = am \ b;
end