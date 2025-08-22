% euler_method.m
% 欧拉法解 dy/dx = f(x,y)

clc; clear; close all;

f = @(x,y) y - x.^2 + 1; % ODE
a = 0; b = 2; h = 0.2;
x = a:h:b;
y = zeros(size(x));
y(1) = 0.5;

for i=1:length(x)-1
    y(i+1) = y(i) + h*f(x(i),y(i));
end

plot(x,y,'bo-');
title('欧拉法解 ODE');