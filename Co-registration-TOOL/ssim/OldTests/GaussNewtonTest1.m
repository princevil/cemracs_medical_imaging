global griglia R
griglia = uniform2d(5,5);
R = reference(griglia.x,griglia.y);

options=optimeset('GradObj','on');

fmninunc(@costo,[0,0]);
