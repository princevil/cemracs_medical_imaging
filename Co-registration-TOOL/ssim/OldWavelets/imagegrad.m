function [gradx,grady]=imagegrad(image)
global GX GY
gradx = GX*image;
grady = GY*image;