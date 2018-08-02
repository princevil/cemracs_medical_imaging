global griglia R Mass
griglia = uniform2d(5,5);
R = reference(griglia.x,griglia.y);

a0 = [2.4;.3;.2;.2;0.7;.1];

disp(['GradObj','on','LargeScale','off']);
options=optimset('GradObj','on','LargeScale','off','TolX',1.e-15);
fminunc(@costo,a0,options);
ans

disp(['GradObj','off','LargeScale','off']);
options=optimset('GradObj','off','LargeScale','off','TolX',1.e-15);
fminunc(@costo,a0,options);
ans

disp(['GradObj','on','LargeScale','on']);
options=optimset('GradObj','on','LargeScale','on','TolX',1.e-15);
fminunc(@costo,a0,options);
ans

disp(['GradObj','on','Hessian','on','LargeScale','on']);
options=optimset('GradObj','on','Hessian','on','LargeScale','on','TolX',1.e-15);
fminunc(@costo,a0,options);
ans
