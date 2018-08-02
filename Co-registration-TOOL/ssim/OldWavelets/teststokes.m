
gamma=0;

basep=start(3,6);
baseu=start(5,6);

gridu=uniform2d(baseu.J0,baseu.J0);
gridp=uniform2d(basep.J0+1,basep.J0+1);

massu=operator2d(gridu,gridu,[1 0 0; 0 0 0; 0 0 0],baseu);
stiff=operator2d(gridu,gridu,[0 0 -1; 0 0 0; -1 0 0],baseu);

duy=operator2d(gridu,gridp,[0 1 0;0 0 0;0 0 0],baseu);
dux=operator2d(gridu,gridp,[0 0 0;1 0 0;0 0 0],baseu);

massp=operator2d(gridp,gridp,[1 0 0; 0 0 0; 0 0 0],basep);

dpy=operator2d(gridp,gridu,[0 1 0;0 0 0;0 0 0],basep);
dpx=operator2d(gridp,gridu,[0 0 0;1 0 0;0 0 0],basep);
stab=operator2d(gridp,gridp,[0 0 -1; 0 0 0; -1 0 0],basep);

[ndofu,junk]=size(gridu);
[ndofp,junk]=size(gridp);

ndof=2*ndofu+ndofp;

S=zeros(ndof);
S(1:ndofu,1:ndofu)=stiff;
S(ndofu+1:2*ndofu,ndofu+1:2*ndofu)=stiff;
S(1:ndofu,2*ndofu+1:2*ndofu+ndofp)=dpx;
S(ndofu+1:2*ndofu,2*ndofu+1:2*ndofu+ndofp)=dpy;
S(2*ndofu+1:2*ndofu+ndofp,1:ndofu)=dux;
S(2*ndofu+1:2*ndofu+ndofp,ndofu+1:2*ndofu)=duy;

S(2*ndofu+1:2*ndofu+ndofp,2*ndofu+1:2*ndofu+ndofp)=gamma*stab;



f=zeros(ndof,1);
% f(1:ndofu*2)=ones(2*ndofu,1);

x=gridu(:,4); y=gridu(:,5);


ib=logical(gridu(:,6));
S(ib,:)=0*S(ib,:);
S(ib,1:ndofu)=massu(ib,:);
ib2=zeros(2*ndofu,1); ib2(ndofu+1:2*ndofu)=ib; ib2=logical(ib2);
S(ib2,:)=0*S(ib2,:);
S(ib2,ndofu+1:2*ndofu)=massu(ib,:);

f(ib)=0*f(ib);
f(ib2)=0*f(ib2);

meanp=[zeros(1,2*ndofu) sum(massp)]; 
S = [S; meanp];



f = [f; 0];

% v=ones(ndofu,1);
% ibce=logical(gridu(:,3)==2.^gridu(:,1));
% f(ibce)=100*v(ibce);

% v=S\f;

% v1=v(1:ndofu); u1=massu*v1;
% v2=v(ndofu+1:2*ndofu); u2=massu*v2;
% v3=v(2*ndofu+1:ndof); p=massp*v3;


% figure(1); plot2d(u1,gridu); view(2);

% figure(2); plot2d(u2,gridu); view(2);

% figure(3); plot2d(p,gridp); view(2);