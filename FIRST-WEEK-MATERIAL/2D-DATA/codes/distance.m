function [ d ] = distance( p1, p2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

d = sqrt( sum((p1 - p2).^2));

end

