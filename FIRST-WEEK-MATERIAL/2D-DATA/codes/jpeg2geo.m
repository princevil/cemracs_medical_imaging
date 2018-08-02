function [VER,TRI] = jpeg2geo(picture_filename,filename,tolerance = 1e-02,h = 2)

%% ONLY ADAPTED FOR ONE CONTOUR

filename = strcat(filename,'.geo');
cont = jpeg2contour(picture_filename,tolerance,h);

plot(cont(1,:),cont(2,:))

%% writes .geo file

[pointer,message] = fopen(filename,'w');
fprintf(pointer,'h = %i;\n',20);

L = size(cont,2);

             for point = 1:L
       	       fprintf(pointer,'Point(%i) = {%f,%f,%i,h};\n',point,cont(1,point),cont(2,point),0);
	     end
	     fprintf(pointer,'\n');

             for segment = 1:L
			     fprintf(pointer,'Line(%i) = {%i, %i};\n',segment,segment,(segment+1)*(segment+1<=L) + (segment==L));
             end
	     fprintf(pointer,'\n\n');
            
             fprintf(pointer,'Line Loop(%i) = {',L+1);
             for segment = 1:L-1
	       fprintf(pointer,'%i ,',segment);
             end
	     fprintf(pointer,'%i};\n\n',L);

fprintf(pointer,'Plane Surface(%i) = {%i};\n\n',L+2,L+1);
	     
fclose(pointer);

end
