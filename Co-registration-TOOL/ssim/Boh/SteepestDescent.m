clear all;
N = 2;b=zeros(N,1);
griglia = uniform2d(5,5);
h = 1/2.^griglia.j0;


R = reference(griglia.x,griglia.y);


k = 0;
a = [0.0; -0.21];
lambda = .1;
Ta = deforma(a,griglia);
res0 = sqrt((Ta-R)'*(Ta-R))*h;
for i = 1:1
    if (res0<=1e-6) disp(['Urrah! - iterazione ',num2str(i)]); break, end
    
    
    gradTa = gradiente(a,griglia);
   
    for j = 1:N,
        b(j) = (Ta - R)'*gradTa(:,j);
    end
    
    for iter=1000,
       a = a+lambda*b;
       Ta = deforma(a,griglia);
       res1 = sqrt((Ta-R)'*(Ta-R))*h
       if(res1 < res0) res0 = res1; break; end
       lambda=lambda/2;
    end
   

end