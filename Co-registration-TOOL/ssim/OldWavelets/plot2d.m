function []=plot2d(z,grid)

% costruzione della griglia plot

xt=(0:.1:1);
yt=(0:.1:1);
[xx,yy]=meshgrid(xt,yt);

% interpolazione

zz=griddata(grid.x,grid.y,z,xx,yy);

surf(xx,yy,zz);