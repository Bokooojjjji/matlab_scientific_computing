function [lambda, v, it] = inverse_power_shift(A, mu, v0, tol, maxit)
% 求接近 mu 的特征值/特征向量
if nargin<3 || isempty(v0), v0 = randn(size(A,1),1); end
if nargin<4, tol = 1e-10; end
if nargin<5, maxit = 1000; end
n = size(A,1);
M = A - mu*speye(n);
[L,U,P] = lu(M); % 预分解提高效率
v = v0/norm(v0); lambda = mu;
for it=1:maxit
    w = U \ (L \ (P*v));  % 解 (A-muI) w = v
    v = w / norm(w);
    lambda = v'*(A*v)/(v'*v); % Rayleigh商
    if norm(A*v - lambda*v) < tol*(1+abs(lambda)), break; end
end
end