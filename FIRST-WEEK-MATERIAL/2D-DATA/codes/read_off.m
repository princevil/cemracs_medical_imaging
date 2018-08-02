function [ver,face]=read_off(filename)
 
% Copyright Giuseppe Patan?? CNR-IMATI patane@ge.imati.cnr.it
 
  [fid,message]=fopen(filename, 'r');
if( fid==-1 )
  disp(message);
return;
end
 
str=fgets(fid); 
if( ~strcmp(str(1:3),'OFF') )
  error('The file is not a valid OFF one.');    
end
 
str=fgetl(fid); 
if( isempty(str) )
  str=fgets(fid);
end
[a,str]=strtok(str); num_ver=str2num(a);
[a,str]=strtok(str); num_face=str2num(a);
 
[ver,count]=fscanf(fid,'%f %f %f',3*num_ver);
if( count~=3*num_ver )
  disp('Problem in reading vertices.');
end
ver=reshape(ver,3,num_ver);
ver=ver'; 
 
face=[];
if( strfind(filename,'quad') )
    position=ftell(fid); list=textscan(fid,'%n%*[^\n]'); 
    list=list{1,1}; card=max(list); 
    for i=1:card
        index=find(list==i); 
        if( ~isempty(index) )
            face(i).dim=0;
            face(i).patch=zeros(size(index,1),i);
        end
    end
     
    status=fseek(fid,position,'bof'); 
    for i=1:num_face
        card=fscanf(fid,'%d',1); 
        list=fscanf(fid,'%d',card); list=list+1;
 
        face(card).dim=face(card).dim+1;
        face(card).patch(face(card).dim,:)=list'; 
    end
 else
   tline=fgetl(fid); 
tline=fgetl(fid);
f1=str2num(tline); 
if( size(f1,2)==4 )
  [face,count] = fscanf(fid,'%f %f %f %f\n',4*num_face); card=4;
 else
   [face,count] = fscanf(fid,'%f %f %f %f %f %f %f\n',4*num_face); card=7;
    end
    face=[f1';face];
 
    if( count~=card*num_face )
        disp('Problem in reading faces.');
    end
    face=reshape(face,card,num_face);
    face=face(2:4,:)'+1; 
end
	    fclose(fid);
