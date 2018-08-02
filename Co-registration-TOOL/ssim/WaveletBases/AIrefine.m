function v = AIrefine(base,maxlev)
%   function v = AIrefine(base,maxlev)


D = base.D; h = base.h;



 A = zeros(2*D,2*D);
 for n=-D+1:D,
     for l = max(-D+1,2*n-D-1):min(2*n+D,D)
        A(n+D,l+D)=h(2*n-l+D+1);
     end
 end
 
 [Evec,Eval]=eig(A);
 logi = (1.-1.e-10<diag(Eval))&(1.+1.e-10>diag(Eval));
 
 v = Evec(:,logi);
 v = v/sum(v);
 
 v = [0; v; 0];

% v = zeros(2*D+2,1);
% v(D+1)=1;
 
h=h/2;


for j=1:maxlev
	step=2^(j-1);
    even = zeros(2*D+2,step);
	for ioffset=0:step-1
        l = length(v(ioffset+1:step:length(v)));
		even(1:l,ioffset+1)=v(ioffset+1:step:length(v));
    end
    
	v=zeros((2*D+1)*2^j+1,1);
	even=convn(even,2*h);
	for ioffset=0:step-1
        l = length(v(ioffset+1:step:length(v)));
		v(ioffset+1:step:length(v))=even(1:l,ioffset+1);
	end
end



