% simpson_rule.m
% Simpson 积分公式

clc; clear; close all;

f = @(x) exp(-x.^2);
a = 0; b = 1; n = 10; % n 必须为偶数
h = (b-a)/n;

x = a:h:b;
y = f(x);

I = h/3 * (y(1)+y(end) + 4*sum(y(2:2:end-1)) + 2*sum(y(3:2:end-2)));

disp(['积分结果 I ≈ ', num2str(I)]);
