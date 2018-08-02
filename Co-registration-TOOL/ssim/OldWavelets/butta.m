clear all


j0=1 
jmax=2


grid=zeros((2^jmax+1)^2,6);

v=(0:2^j0);
ky=repmat(v,2^j0+1,1); ky=reshape(ky,(2^j0+1)^2,1);
kx=repmat(v',1,2^j0+1); kx=reshape(kx,(2^j0+1)^2,1);

grid(1:(2^j0+1)^2,1)=j0*ones((2^j0+1)^2,1);
grid(1:(2^j0+1)^2,2)=kx;
grid(1:(2^j0+1)^2,3)=ky;


for j=j0+1:jmax

grid((2^(j-1)+1)^2+1:(2^j+1)^2,1)=j*ones(2^(j-1)*(3*2^(j-1)+2),1);

vx=(1:2:2^j-1);
vy=(0:2:2^j);
ky=repmat(vy,2^(j-1),1); ky=reshape(ky,(2^(j-1)+1)*2^(j-1),1);
kx=repmat(vx',1,2^(j-1)+1); kx=reshape(kx,(2^(j-1)+1)*2^(j-1),1);
grid((2^(j-1)+1)^2+1:(2^(j-1)+1)*(2^j+1),2)=kx;
grid((2^(j-1)+1)^2+1:(2^(j-1)+1)*(2^j+1),3)=ky;



vy=(1:2:2^j-1);
vx=(0:2:2^j);
ky=repmat(vy,2^(j-1)+1,1); ky=reshape(ky,(2^(j-1)+1)*2^(j-1),1);
kx=repmat(vx',1,2^(j-1)); kx=reshape(kx,(2^(j-1)+1)*2^(j-1),1);
grid((2^(j-1)+1)*(2^j+1)+1:(2^(j-1)+1)*(3*2^(j-1)+1),2)=kx;
grid((2^(j-1)+1)*(2^j+1)+1:(2^(j-1)+1)*(3*2^(j-1)+1),3)=ky;


vy=(1:2:2^j-1);
vx=(1:2:2^j-1);
ky=repmat(vy,2^(j-1),1); ky=reshape(ky,2^j,1);
kx=repmat(vx',1,2^(j-1)); kx=reshape(kx,2^j,1);
grid((2^(j-1)+1)*(3*2^(j-1)+1)+1:(2^j+1)^2,2)=kx;
grid((2^(j-1)+1)*(3*2^(j-1)+1)+1:(2^j+1)^2,3)=ky;

end

grid(:,4)=grid(:,2).*2.^(-grid(:,1));
grid(:,5)=grid(:,3).*2.^(-grid(:,1));

grid(:,6)=((grid(:,2)==0)|(grid(:,3)==0)|(grid(:,2)==2.^grid(:,1))|(grid(:,3)==2.^grid(:,1)));