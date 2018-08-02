function S=operator2d(space,grid,coefs,base)



ndof=space.npoints;
ntest=grid.npoints;

S=sparse(ntest,ndof);




for i=1:ndof,
	
	m=space.j(i); kx=space.kx(i); ky=space.ky(i);
	
	columnx=buildcol(m,kx,[grid.j grid.kx],base);
	columny=buildcol(m,ky,[grid.j grid.ky],base);
	
	for idx=0:2
		for idy=0:2-idx
        	S(:,i)=S(:,i)+coefs(idx+1,idy+1)*2^(m*(idx+idy))*columnx(:,idx+1).*columny(:,idy+1);
		end
	end
end