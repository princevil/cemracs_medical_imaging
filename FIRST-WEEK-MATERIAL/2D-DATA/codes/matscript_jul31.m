clear all
close all
clc
%%
[ver, face] = read_off('mesh_atlas.OFF'); %read the mesh
%%
pict = imread('atlas.jpg'); %read the picture
%pict = flipud(pict);
%% plot the image and the former mesh
figure()
subplot(121)
imshow(pict)
title('Image')
subplot(122)
trimesh(face, ver(:,1), ver(:,2), ver(:,3))
view(2)
axis equal
axis off
title('Mesh')
%% compute the baricenter of triangles
mid = mp_edges(ver, face);
%% plot the baricenters of the elements on the mesh
trimesh(face, ver(:,1), ver(:,2), ver(:,3))
view(2)
axis equal
axis off
hold on
plot3(round(mid(:,1)), round(mid(:,2)), round(mid(:,3)), 'x')
%% eliminate the non-physical elements of the former mesh
clc
[new_face, index] = cut_blacks(pict, mid, face);
%% (refinement by Philippe <-- to be consedered in the future, maybe...)
% clc
% [ver, face] = refine(ver(:,1:2), new_face, 15) 
%% plot the image and the correct mesh
figure()
subplot(121)
imshow(pict)
title('Image')
subplot(122)
trimesh(new_face, ver(:,1), ver(:,2), ver(:,3))
%hold on
%plot3(round(mid(:,1)), round(mid(:,2)), round(mid(:,3)), 'x')
view(2)
axis equal
axis off
title('Mesh')
%%
% model = createpde();
% % model = []
% geometryFromMesh(model,ver',new_face');
% pdegplot(model,'FaceLabels','on','FaceAlpha',0.5)
