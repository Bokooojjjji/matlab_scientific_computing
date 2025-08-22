function [root,it] = secant(f,x0,x1,tol,maxit)
if nargin<4, tol=1e-10; end
if nargin<5, maxit=100; end
for it=1:maxit
    fx0=f(x0); fx1=f(x1);
    if abs(fx1-fx0)<eps, break; end
    x2 = x1 - fx1*(x1-x0)/(fx1-fx0);
    if abs(x2-x1) < tol*(1+abs(x2)), root=x2; return; end
    x0=x1; x1=x2;
end
root=x1;
end