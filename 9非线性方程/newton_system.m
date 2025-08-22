function [x,it] = newton_system(F,x0,tol,maxit)
% F: R^n->R^n 的向量函数句柄，数值雅可比
if nargin<3, tol=1e-10; end
if nargin<4, maxit=50; end
x=x0(:); n=numel(x); epsJ=1e-6;
for it=1:maxit
    Fx = F(x);
    if norm(Fx) < tol, return; end
    % 数值雅可比
    J=zeros(n); 
    for j=1:n
        e=zeros(n,1); e(j)=epsJ*max(1,abs(x(j)));
        J(:,j)=(F(x+e)-Fx)/e(j);
    end
    dx = - J \ Fx;
    x_new = x + dx;
    if norm(dx) < tol*(1+norm(x_new)), x=x_new; return; end
    x = x_new;
end
end