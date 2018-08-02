function v = refine(a,id,maxlev)
nw=length(a); L=2*nw-1;
v=valori(a,id);  % niveau 0
h=2^id*filtro(a);

for j=1:maxlev
	step=2^(j-1);
	odd=zeros((length(v)+1)/step,step-1);
	for ioffset=1:step-1
		odd(:,ioffset)=v(ioffset:step:length(v));
	end
	even=v(step:step:length(v));
	v=zeros(L*2^(j+1)-1,1);
	if(j>1), 
	odd=convn(odd,h); 
	end
	even=conv(even,h);
	for ioffset=1:step-1
		v(ioffset:step:length(v))=odd(:,ioffset);
	end
	v(step:step:length(v))=even;
end

