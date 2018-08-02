function z = checkb(x,y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

N=2;

x = (N*x-floor(N*x)); y=(N*y - floor(N*y));

lz =((x<.5)&(y<.5))|((x>.5)&(y>.5));

z = zeros(size(x));
z(lz)=ones(sum(lz),1);

end

