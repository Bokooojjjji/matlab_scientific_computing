% trapezoidal_rule.m
% 梯形积分公式

clc; clear; close all;

f = @(x) exp(-x.^2);
a = 0; b = 1; n = 10;
h = (b-a)/n;

x = a:h:b;
y = f(x);

I = h*(sum(y)-0.5*(y(1)+y(end)));

disp(['积分结果 I ≈ ', num2str(I)]);