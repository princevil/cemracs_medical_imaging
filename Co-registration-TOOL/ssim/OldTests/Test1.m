global griglia R
griglia = uniform2d(5,5);
R = reference(griglia.x,griglia.y);

options=optimset('GradObj','on');

fminunc(@costo,[0,0,0,0]);

