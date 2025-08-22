% rk4_method.m
% 四阶 Runge-Kutta 方法

clc; clear; close all;

f = @(x,y) y - x.^2 + 1;
a = 0; b = 2; h = 0.2;
x = a:h:b;
y = zeros(size(x));
y(1) = 0.5;

for i=1:length(x)-1
    k1 = f(x(i), y(i));
    k2 = f(x(i)+h/2, y(i)+h*k1/2);
    k3 = f(x(i)+h/2, y(i)+h*k2/2);
    k4 = f(x(i)+h, y(i)+h*k3);
    y(i+1) = y(i) + h/6*(k1+2*k2+2*k3+k4);
end

plot(x,y,'ro-');
title('四阶 Runge-Kutta 解 ODE');