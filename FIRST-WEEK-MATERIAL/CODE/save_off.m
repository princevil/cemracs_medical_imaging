function []=save_off(input_ver,input_tri,filename)

% Copyright Giuseppe Patanè CNR-IMATI patane@ge.imati.cnr.it

%folder='C:\Documents and Settings\patane\matlab-test\120-new\';
folder='';

filename=strcat(folder,strcat(filename,'.OFF')); 
if( ~isempty(input_ver) || ~isempty(input_tri))    
    [pointer,message]=fopen(strcat(filename),'w');
    
    num_ver=size(input_ver,1); num_tri=size(input_tri,1);
    
    if( pointer==-1 )
        disp(message);
    end
    
    fprintf(pointer,'%s\n','OFF');
    fprintf(pointer,'\n%d %d %d\n',num_ver,num_tri,0);
    for i=1:num_ver
        fprintf(pointer,'%f %f %f\n',input_ver(i,1),input_ver(i,2),input_ver(i,3));
    end

    input_tri=input_tri-1;
    for i=1:num_tri
        fprintf(pointer,'%d %d %d %d\n',...
            3,input_tri(i,1),input_tri(i,2),input_tri(i,3));
    end  
    fclose(pointer);
end