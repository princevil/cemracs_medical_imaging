function [norms_vector] = componentwise_norm(listofpoints)

  % computes the list of norms of a list of points ; size = (2,npoints)

  npoints = size(listofpoints,2);
norms_vector = sqrt( listofpoints(1,:).^2 + listofpoints(2,:).^2 );

end
