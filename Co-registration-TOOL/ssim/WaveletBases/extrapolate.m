function ye = extrapolate(x,y,xe,p)

ye=[];

if(~isempty(xe))

	npe=length(xe);
	[ny,nx]=size(y);
	ye=zeros(ny,npe);
	
	for i=1:ny,
		coefs=polyfit(x,y(i,:),p);
		ye(i,:)=polyval(coefs,xe);
	end

end
