function [ new_face, index ] = cut_blacks( pict, mid, face )
%cut_blacks returns the good mesh

pict = flipud(pict);
nfaces = size(face,1);
index = [];
for i = 1:nfaces
    if pict( ceil(mid(i,2)), ceil(mid(i,1))) <= 100
        index = [index, i];
%         break
    end
end

face(index,:) = [];
new_face = face;

end

