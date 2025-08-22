% 常用数值积分函数示例
f = @(x) exp(-x.^2);
I1 = integral(f,0,1);                 % 自适应高精度一维
I2 = integral2(@(x,y) x.*y,0,1,0,1);  % 二重积分
I3 = integral3(@(x,y,z) x+y+z,0,1,0,1,0,1); % 三重
Iosc = quadgk(@(x) sin(100*x)./x, 1e-3, 1); % 振荡积分（自适应Gauss-Kronrod）
fprintf('integral: %.12f, integral2: %.12f, integral3: %.12f, quadgk: %.12f\n',I1,I2,I3,Iosc);