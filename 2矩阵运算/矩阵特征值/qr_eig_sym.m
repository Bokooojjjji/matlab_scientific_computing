function [D,it] = qr_eig_sym(A, tol, maxit)
% 只适合对称实矩阵，返回对角 D（近似特征值）
if nargin<2, tol = 1e-10; end
if nargin<3, maxit = 500; end
Ak = A;
for it=1:maxit
    [Q,R] = qr(Ak);
    Ak = R*Q;
    off = norm(Ak - diag(diag(Ak)),'fro');
    if off < tol*(1+norm(A,'fro')), break; end
end
D = diag(Ak);
end