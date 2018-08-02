
base=start(3,5);

grid =uniform1d(base.J0,base.J+base.J0-1);

R = operator(base,grid,[0 1 0]);

v=zeros(2^(base.J+base.J0-1),2^(base.J0));
v(1:2^(base.J0),1:2^(base.J0))=eye(2^(base.J0));

y=R*v;

[x,I]=sort(grid(:,3));

plot(x,y(I,:));

