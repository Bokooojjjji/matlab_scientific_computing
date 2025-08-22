function [x,it] = gauss_seidel_iter(A,b,x0,tol,maxit)
if nargin<3||isempty(x0), x0=zeros(size(b)); end
if nargin<4, tol=1e-8; end
if nargin<5, maxit=10000; end
L = tril(A); U = triu(A,1);
x = x0;
for it=1:maxit
    x_new = L \ (b - U*x);
    if norm(x_new-x)/max(1,norm(x_new)) < tol, x=x_new; return; end
    x = x_new;
end
end