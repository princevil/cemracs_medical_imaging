clear all
global spazio griglia R Mass

base=start(1,9);

griglia = uniform2d(5,5);
R = reference(griglia.x,griglia.y);
subplot(3,1,1); plot2d(R,griglia);view(2)

spazio = uniform2d(0,0);
Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base);

disp('costruito operatore di massa');a0 = zeros(2*spazio.npoints,1);
T0 = deforma(a0,griglia);
options=optimset('GradObj','off','MaxFunEvals',1000,'DerivativeCheck','on',...
    'TolFun',1.e-3,'TolX',1.e-3,'LargeScale','off');
% options=optimset('GradObj','off','MaxFunEvals',1000,'DerivativeCheck','on')
a1 = fminunc(@costo,a0,options);
T1 = deforma(a1,griglia);
subplot(3,1,2); plot2d(T1,griglia);view(2)
N0 = spazio.npoints;
a1

pause;
%
options=optimset('GradObj','on','MaxFunEvals',1000,'DerivativeCheck','on',...
    'TolFun',1.e-6,'TolX',1.e-6,'LargeScale','on');
spazio = uniform2d(0,1);
Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base);
a0 = zeros(2*spazio.npoints,1);
a0(1:N0)=a1(1:N0);
a0(spazio.npoints+1:spazio.npoints+N0)=a1(N0+1:2*N0);
N0 = spazio.npoints;
a2 = fminunc(@costo,a0,options);
T2 = deforma(a2,griglia);
subplot(3,1,3); plot2d(T2,griglia);view(2)
a2


% 

pause;
%
options=optimset('GradObj','on','MaxFunEvals',1000,'DerivativeCheck','on',...
    'TolFun',1.e-6,'TolX',1.e-6,'LargeScale','on');
spazio = uniform2d(0,2);
Mass = operator2d(spazio,griglia,[1 0 0;0 0 0;0 0 0],base);
a0 = zeros(2*spazio.npoints,1);
a0(1:N0)=a2(1:N0);
a0(spazio.npoints+1:spazio.npoints+N0)=a2(N0+1:2*N0);
N0 = spazio.npoints;
a2 = fminunc(@costo,a0,options);
T2 = deforma(a2,griglia);
subplot(3,1,3); plot2d(T2,griglia);view(2)
a2

% 
