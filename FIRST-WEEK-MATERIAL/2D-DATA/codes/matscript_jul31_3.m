clear all
close all
clc
%%
pict = imread('atlas-higher.jpg'); %read the picture
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
plot(c(1,:), c(2,:), '*')
axis equal
%%
cc = c;
npoints = size(cc, 2);
epsilon = 1e-4;
index = [];
for i = 2:npoints-1
%     abs(distance(cc(:,i-1), cc(:,i+1)) - distance(cc(:,i-1), cc(:,i)) -...
%             distance(cc(:,i), cc(:,i+1)))
    if abs(distance(cc(:,i-1), cc(:,i+1)) - distance(cc(:,i-1), cc(:,i)) -...
            distance(cc(:,i), cc(:,i+1))) < epsilon
        index = [index, i];
    end
end
if abs(distance(cc(:,end), cc(:,2)) - distance(cc(:,end), cc(:,1)) -...
            distance(cc(:,1), cc(:,2))) < epsilon
    index = [index, 1];
end
if abs(distance(cc(:,end-1), cc(:,2)) - distance(cc(:,end-1), cc(:,1)) -...
            distance(cc(:,1), cc(:,2))) < epsilon
    index = [index, npoints];
end

cc(:,index) = [];
%%
figure()
subplot(121)
plot(c(1,:), c(2,:), '*')
axis equal
title(['former borders', ' n=', num2str(size(c,2))])
subplot(122)
plot(cc(1,:), cc(2,:), '*')
axis equal
title(['new borders', ' n=', num2str(size(cc,2))])
%%
tric = delaunay(c(1,:), c(2,:));
tricc = delaunay(cc(1,:), cc(2,:));

figure()
subplot(121)
trimesh(tric, c(1,:), c(2,:))
title('starting')
axis equal
subplot(122)
trimesh(tricc, cc(1,:), cc(2,:))
title('new')
axis equal
%%
nc = size(c,2);
ncc = size(cc,2);
midc = mp_edges([c; zeros(1,nc)]', tric);
midcc = mp_edges([cc; zeros(1,ncc)]', tricc);
%%
figure()
subplot(121)
trimesh(tric, c(1,:), c(2,:))
axis equal
axis off
hold on
plot(round(midc(:,1)), round(midc(:,2)), 'x')
title('starting')
subplot(122)
trimesh(tricc, cc(1,:), cc(2,:))
axis equal
axis off
hold on
plot(round(midcc(:,1)), round(midcc(:,2)), 'x')
title('new')
%%
clc
[new_facec, ic] = cut_blacks(flipud(pict), midc, tric);
[new_facecc, icc] = cut_blacks(flipud(pict), midcc, tricc);
%%
figure()
subplot(121)
trimesh(new_facec, c(1,:), c(2,:))
%hold on
%plot3(round(mid(:,1)), round(mid(:,2)), round(mid(:,3)), 'x')
view(2)
axis equal
axis off
title('Mesh (start)')
subplot(122)
trimesh(new_facecc, cc(1,:), cc(2,:))
%hold on
%plot3(round(mid(:,1)), round(mid(:,2)), round(mid(:,3)), 'x')
view(2)
axis equal
axis off
title('Mesh (new)')
%%
% nedges = size(c,2);
% pdepoly(c(1,:), c(2,:))