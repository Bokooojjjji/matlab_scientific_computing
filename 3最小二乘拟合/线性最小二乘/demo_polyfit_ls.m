x = (0:0.5:5)'; y = exp(-0.5*x) + 0.05*randn(size(x));
p = polyfit_ls(x, y, 2);
xx = linspace(min(x), max(x), 200);
yy = polyval(p, xx);
plot(x,y,'ro',xx,yy,'b-','LineWidth',1.5); legend('数据','拟合');
title('QR 的多项式最小二乘拟合');