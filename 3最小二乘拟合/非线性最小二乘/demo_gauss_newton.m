x = (0:0.5:5)'; true_a=2; true_b=-0.5;
y = true_a*exp(true_b*x) + 0.05*randn(size(x));

resfun = @(th) (th(1)*exp(th(2)*x) - y); % 残差
[th, info] = gauss_newton_nls(resfun, [1; -0.1], 1e-8, 100);
fprintf('估计参数: a=%.4f, b=%.4f, 残差范数=%.2e, 迭代=%d\n', ...
    th(1), th(2), info.final_resnorm, info.iters);

xx = linspace(min(x),max(x),200)';
yy = th(1)*exp(th(2)*xx);
plot(x,y,'ro', xx,yy,'b-','LineWidth',1.5); legend('数据','拟合');
title('Gauss-Newton 非线性最小二乘');