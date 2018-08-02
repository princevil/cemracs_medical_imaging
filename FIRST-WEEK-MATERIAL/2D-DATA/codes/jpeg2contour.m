function [cont] = jpeg2contour(filename,tolerance,h)

pict = imread(filename);
pict = flipud(pict);
pict = add_margin(pict);

cont = contourc(pict,[200,200]);
cont = remove_metadata(cont);
cont = smooth3(cont,tolerance);
cont = average(cont,h);

end
