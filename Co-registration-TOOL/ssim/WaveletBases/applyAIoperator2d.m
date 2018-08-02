function [Ti,DXi,DYi]=applyAIoperator2d(T,space,grid,base)

disp('Inizio applyAIoperator');

ndof=space.nfun;
ntest=grid.npoints;

Ti = zeros(ntest,1);
DXi = zeros(ntest,1);
DYi = zeros(ntest,1);
M=sparse(ntest,ndof);
DX=sparse(ntest,ndof);
DY=sparse(ntest,ndof);


for i=1:ndof,
	
   
	m=space.j(i); kx=space.kx(i); ky=space.ky(i);

    
	columnx=AIbuildcol(m,kx,0,[grid.j grid.kx grid.x],base);
	columny=AIbuildcol(m,ky,0,[grid.j grid.ky grid.y],base);
	
    columnx=sparse(columnx); columny=sparse(columny);
    Ti(:) = Ti(:)+ T(i)*columnx(:,1).*columny(:,1);
    DXi(:) = DXi(:)+T(i)*2^m*columnx(:,2).*columny(:,1);
    DYi(:) = DYi(:)+T(i)*2^m*columnx(:,1).*columny(:,2);
    
    
% 	for idx=0:1
% 		for idy=0:2-idx
%         	S(:,i)=S(:,i)+coefs(idx+1,idy+1)*2^(m*(idx+idy))*columnx(:,idx+1).*columny(:,idy+1);
% 		end
% 	end
end

disp('Fine applyAIoperator');
