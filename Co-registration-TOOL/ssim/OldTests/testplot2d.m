% costruzione della griglia ondine

grid=uniform2d(2,5);

x=grid(:,4); y=grid(:,5);
z=sin(x).*cos(y)+1;

% costruzione della griglia plot

xt=(0:.1:1);
yt=(0:.1:1);
[xx,yy]=meshgrid(xt,yt);

% interpolazione

zz=griddata(x,y,z,xx,yy);

surf(xx,yy,zz);