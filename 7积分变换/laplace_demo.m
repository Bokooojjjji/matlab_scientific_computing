% laplace_demo.m
% 拉普拉斯变换示例 (需要 Symbolic Toolbox)

clc; clear; close all;
syms t s

f = exp(-2*t)*sin(3*t);
F = laplace(f,t,s);

disp('f(t) 的拉普拉斯变换：');
pretty(F);