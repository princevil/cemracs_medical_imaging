function [Tx,Ty]=DT(x,y);

global Xi Yi Dxi Dyi Li

x = x - floor(x);
y = y - floor(y);


x = vector2matrix(x,Li);
y = vector2matrix(y,Li);

Tx = interp2(Xi,Yi,Dxi,x,y,'linear');
Tx = matrix2vector(Tx,Li);

Ty = interp2(Xi,Yi,Dyi,x,y,'linear');
Ty = matrix2vector(Ty,Li);
