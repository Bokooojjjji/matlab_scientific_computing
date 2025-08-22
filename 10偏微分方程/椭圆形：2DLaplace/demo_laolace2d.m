gL=@(y) 0; gR=@(y) 0; gB=@(x) 0; gT=@(x) sin(pi*x);
[x,y,U,it]=laplace2d_gs(101,101,gL,gR,gB,gT,1e-6,2e5);
surf(x,y,U); title(sprintf('Laplace GS it=%d',it)); shading interp