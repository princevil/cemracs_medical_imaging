clear all
close all
clc
%%
pict = imread('atlas-lower-square.jpg'); %read the picture
%pict = flipud(pict);
%% plot the image and the former mesh
figure()
imshow(pict)
title('Image')
%% 
c = contourc(double(pict), [200, 200]);
%%
metacoord = [1];
              while metacoord(end) <= length(c(1,:))
                temp = metacoord(end) + c(2,metacoord(end)) + 1;
                if temp >= length(c(1,:)) + 1
                          break
                end
                metacoord(end + 1) = temp;
              end
c(:,metacoord) = []; 
%%
%c = [c, c(:,1)];
%%
c = c(:, 1:end-1);
figure()
plot(c(1,:), c(2,:))
%%
nedges = size(c,2);
pdepoly(c(1,:), c(2,:))