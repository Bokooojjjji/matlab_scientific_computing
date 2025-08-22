% spline_demo.m
% 演示三次样条插值

clc; clear; close all;

x = 0:3;
y = [1 2 0 4];

xx = linspace(0,3,200);
yy = spline(x,y,xx);

plot(x, y, 'ro', 'MarkerFaceColor','r');
hold on;
plot(xx, yy, 'b-', 'LineWidth', 1.5);
title('三次样条插值');
legend('节点','样条插值');