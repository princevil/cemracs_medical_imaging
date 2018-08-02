function v = AId2(D,maxlev)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

switch D
    case 2
h = [-1/8;1/8;1;1;1/8;-1/8];
    case 4
h = [3/128;-3/128;-11/64;11/64;1;1;11/64;-11/64;-3/128;3/128];
    case 6
h = [-5/1024;5/1024;44/1024;-44/1024;-201/1024;201/1024;1;1;201/1024;...
    -201/1024;-44/1024;44/1024;5/1024;-5/1024];
    case 8
h = MakeAIFilter(8);
    otherwise
        D=2; h = [-1/8;1/8;1;1;1/8;-1/8];
end

hmp = mp(h);


A = mp(zeros(2*D,2*D));
for n=-D+1:D,
    for l = max(-D+1,2*n-D-1):min(2*n+D,D)
       A(n+D,l+D)=hmp(2*n-l+D+1);
    end
end

[Evec,Eval]=eig(A);
logi = (0.25-1.e-10<diag(Eval))&(0.25+1.e-10>diag(Eval));

v = Evec(:,logi);
K = (-D+1:D); 
fac = (3*K.^2-3*K+1)*v/(2*27)
v = v/fac;

v = [0; v; 0];

for j=1:maxlev
	step=2^(j-1);
    even = zeros(2*D+2,step);
	for ioffset=0:step-1
        size(v(ioffset+1:step:length(v)))
        size(even(:,ioffset+1))
        l = length(v(ioffset+1:step:length(v)));
		even(1:l,ioffset+1)=v(ioffset+1:step:length(v));
    end
    
	v=zeros((2*D+1)*2^j+1,1);
	even=convn(even,4*h);
	for ioffset=0:step-1
        l = length(v(ioffset+1:step:length(v)));
		v(ioffset+1:step:length(v))=even(1:l,ioffset+1);
	end
end



