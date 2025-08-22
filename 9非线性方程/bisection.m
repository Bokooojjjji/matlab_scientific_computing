function [root,it] = bisection(f,a,b,tol,maxit)
fa=f(a); fb=f(b);
if fa*fb>0, error('端点同号，无法保证根'); end
if nargin<4, tol=1e-10; end
if nargin<5, maxit=100; end
for it=1:maxit
    c=(a+b)/2; fc=f(c);
    if abs(fc)<tol || (b-a)/2<tol, root=c; return; end
    if fa*fc<0, b=c; fb=fc; else, a=c; fa=fc; end
end
root=(a+b)/2;
end