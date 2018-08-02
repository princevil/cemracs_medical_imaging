function [hpatch]=tin_color_draw(window_title,mat_ver,mat_tri,edge_color,face_color,mat_color,trasp)

% Copyright Giuseppe Patanè CNR-IMATI patane@ge.imati.cnr.it

title(window_title);
if( isempty(mat_color) )
    hpatch=patch('Vertices',mat_ver,'Faces',mat_tri(:,1:3),'EdgeColor',edge_color,...
        'FaceColor',face_color,'MarkerSize',30);    
    
    lighting gouraud; alpha(trasp); material metal; view(3);
    daspect([1 1 1]); axis tight; axis off; grid off;
else
    hpatch=patch('Vertices',mat_ver,'Faces',mat_tri(:,1:3),'EdgeColor',edge_color,...
        'FaceVertexCData',mat_color,'MarkerSize',30,'FaceColor','interp');  
    daspect([1 1 1]); view(3); axis tight; axis off; grid off; 
    %lighting gouraud;
end