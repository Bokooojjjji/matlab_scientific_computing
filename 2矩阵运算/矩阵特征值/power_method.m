function [lambda, v, it] = power_method(A, v0, tol, maxit)
if nargin<2 || isempty(v0), v0 = randn(size(A,1),1); end
if nargin<3, tol = 1e-10; end
if nargin<4, maxit = 1000; end
v = v0 / norm(v0);
lambda_old = 0;
for it = 1:maxit
    w = A*v;
    v = w / norm(w);
    lambda = v'*(A*v); % Rayleigh商
    if abs(lambda - lambda_old) < tol*(1+abs(lambda)), break; end
    lambda_old = lambda;
end
end