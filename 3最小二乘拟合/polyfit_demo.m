% polyfit_demo.m
% 使用多项式最小二乘拟合

clc; clear; close all;

x = 0:0.5:5;
y = exp(-0.5*x) + 0.05*randn(size(x));

% 二次多项式拟合
p = polyfit(x,y,2);

xx = linspace(0,5,200);
yy = polyval(p,xx);

plot(x,y,'ro','MarkerFaceColor','r');
hold on;
plot(xx,yy,'b-','LineWidth',1.5);
title('二次多项式拟合');
legend('数据','拟合曲线');