function [theta, info] = gauss_newton_nls(resfun, theta0, tol, maxit)
% 非线性最小二乘：Gauss-Newton（带数值雅可比）
% resfun(theta) 返回残差向量 r(theta)
% theta0 初值；tol 容差；maxit 最大迭代
% 输出：theta 最优参数；info 过程信息
if nargin<3, tol = 1e-8; end
if nargin<4, maxit = 100; end

theta = theta0(:);
epsJ  = 1e-6;
for k = 1:maxit
    r = resfun(theta);                 % 残差 m×1
    m = numel(r); p = numel(theta);
    % 数值雅可比 J(i,j) = d r_i / d theta_j
    J = zeros(m, p);
    for j = 1:p
        dt = zeros(p,1); dt(j) = epsJ * max(1,abs(theta(j)));
        rj = resfun(theta + dt);
        J(:,j) = (rj - r) / dt(j);
    end

    % Gauss-Newton 步长：解 min||J d + r||，即 J d = -r 的最小二乘解
    d = - J \ r;

    % 简单阻尼线搜索（避免发散）
    alpha = 1.0; f0 = 0.5*(r.'*r);
    while true
        rnew = resfun(theta + alpha*d);
        f1   = 0.5*(rnew.'*rnew);
        if f1 <= f0*(1 - 1e-4*alpha) || alpha < 1e-6, break; end
        alpha = alpha/2;
    end

    theta = theta + alpha*d;
    if norm(d) < tol*(1+norm(theta)), break; end
end

info.iters = k;
info.final_resnorm = norm(resfun(theta));
end