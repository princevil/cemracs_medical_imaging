function [S,D]=AIoperator1d(spazio,grid,base)

ndof=spazio.nfun;
ntest = grid.npoints;
S=zeros(ntest,ndof);
D=zeros(ntest,ndof);

points=[grid.j grid.k];

for i=1:ndof,
	
    m=spazio.j(i); k=spazio.k(i);
    
	column=AIbuildcol(m,k,0,points,base);
	
	S(:,i)=column(:,1);
    D(:,i)=2^m*column(:,2);
	
end

end