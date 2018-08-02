function [picture_margin] = add_margin(picture)

  [i,j] = size(picture);
  picture_margin = zeros(i+4,j+4);
  picture_margin(3:end-2,3:end-2) = picture;

end
