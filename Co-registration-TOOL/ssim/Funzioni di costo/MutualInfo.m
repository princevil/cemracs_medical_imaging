function [Ixy,dpxy]=MutualInfo(X,Y)

 
% Ixy : Mutual Information
% lambda: scaled mutual information 
% X e Y saranno le immagini e bisogna inserirle come vettori colonna!!

X=X';
Y=Y';

d=2;
nx=length(X);
hx=(4/(d+2))^(1/(d+4))*nx^(-1/(d+4));

Xall=[X;Y];
sum1=0;
for l=1:nx
    [pxy,dpxy]=p_mkde([X(l),Y(l)]',Xall,hx);
    [px,dpx]=p_mkde(X(l),X,hx);
    [py,dpy]=p_mkde(Y(l),Y,hx);
    sum1=sum1+pxy.*log(pxy/(px*py));
end

Ixy=sum1/nx;

%lambda=sqrt(1-exp(-2*Ixy));




% Multivariate kernel density estimate using a normal kernel
% with the same h
% input data X : dim * number of records
%            x : the data point in order to estimate mkde (d*1) vector
%            h : smoothing parameter

function [pxy,dsum]=p_mkde(x,X,h)

s1=size(X);
d=s1(1);
N=s1(2);

Sxy=cov(X');
sum=0;
%p1=1/sqrt((2*pi)^d*det(Sxy))*1/(N*h^d);

invS=inv(Sxy);
detS=det(Sxy);
for ix=1:N
    p2=(x-X(:,ix))'*invS*(x-X(:,ix));
    sum=sum+1/sqrt((2*pi)^d*detS)*exp(-p2/(2*h^2));
end
pxy=1/(N*h^d)*sum;
%p_xy=ksedensity(X);

dsum=gradient(sum);


 
