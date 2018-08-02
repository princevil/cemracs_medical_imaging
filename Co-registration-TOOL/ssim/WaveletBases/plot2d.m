function []=plot2d(z,grid)

colormap('gray');

% costruzione della griglia plot

j = max(grid.j);
h = 1/2.^(j-1);

xt=(h/2:h:1-h/2);
yt=(h/2:h:1-h/2);
[xx,yy]=meshgrid(xt,yt);

% interpolazione

zz=griddata(grid.x,grid.y,z,xx,yy,'nearest');

surf(xx,yy,zz,'EdgeColor','none');

view(2)