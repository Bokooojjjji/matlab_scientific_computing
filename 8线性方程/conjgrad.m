function [x,it] = conjgrad(A,b,x0,tol,maxit)
% SPD 矩阵的 CG
if nargin<3||isempty(x0), x0=zeros(size(b)); end
if nargin<4, tol=1e-10; end
if nargin<5, maxit=1000; end
x = x0; r = b - A*x; p = r; rs = r'*r;
for it=1:maxit
    Ap = A*p;
    alpha = rs/(p'*Ap);
    x = x + alpha*p;
    r = r - alpha*Ap;
    rs_new = r'*r;
    if sqrt(rs_new) < tol*max(1,norm(b)), break; end
    beta = rs_new/rs;
    p = r + beta*p;
    rs = rs_new;
end
end