% ode45_demo.m
% 使用 ode45 解 ODE

clc; clear; close all;

f = @(x,y) y - x.^2 + 1;

[x,y] = ode45(f,[0 2],0.5);

plot(x,y,'b-','LineWidth',1.5);
title('ode45 解 ODE');