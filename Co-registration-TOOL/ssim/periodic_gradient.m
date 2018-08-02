function [Gx,Gy] = periodic_gradient(S,h)

[N,M] = size(S);

S1 = [S(:,M),S,S(:,1)];
Gx = (S1(:,3:M+2)-S1(:,1:M))/(2*h);

S1 = [S(N,:);S;S(1,:)];
Gy = (S1(3:N+2,:)-S1(1:N,:))/(2*h);