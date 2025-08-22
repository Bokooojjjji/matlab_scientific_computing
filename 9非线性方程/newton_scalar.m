function [root,it] = newton_scalar(f,df,x0,tol,maxit)
if nargin<4, tol=1e-12; end
if nargin<5, maxit=100; end
x = x0;
for it=1:maxit
    fx=f(x); dfx=df(x);
    if abs(dfx)<eps, error('导数过小'); end
    x_new = x - fx/dfx;
    if abs(x_new-x) < tol*(1+abs(x_new)), root=x_new; return; end
    x = x_new;
end
root=x;
end