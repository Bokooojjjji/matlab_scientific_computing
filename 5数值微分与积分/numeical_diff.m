% numerical_diff.m
% 数值微分

clc; clear; close all;

f = @(x) sin(x);
h = 0.01;
x0 = pi/4;

f_forward = (f(x0+h)-f(x0))/h;
f_backward = (f(x0)-f(x0-h))/h;
f_center = (f(x0+h)-f(x0-h))/(2*h);

disp(['真实导数 f''(pi/4)= ', num2str(cos(x0))]);
disp(['前向差分: ', num2str(f_forward)]);
disp(['后向差分: ', num2str(f_backward)]);
disp(['中心差分: ', num2str(f_center)]);