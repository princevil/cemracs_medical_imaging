function [hatx,haty] = phi(griglia,a)

global Mass;
N = max(size(a))/2;

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% x=griglia.x;
% y=griglia.y;

hatx = griglia.x + Mass * a(1:N);
haty = griglia.y + Mass * a(N+1:2*N);

% hatxx = x + a(1)*(1-x).*(1-y)+a(2)*x.*(1-y)+a(3)*(1-x).*y+a(4)*x.*y;
% hatyy = y + a(5)*(1-x).*(1-y)+a(6)*x.*(1-y)+a(7)*(1-x).*y+a(8)*x.*y;
% 
% norm(hatx-hatxx)
% norm(haty-hatyy)
end


