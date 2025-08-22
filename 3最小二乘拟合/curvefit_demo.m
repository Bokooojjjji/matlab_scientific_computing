% curvefit_demo.m
% 指数函数曲线拟合

clc; clear; close all;

x = 0:0.5:5;
y = 2*exp(-0.5*x) + 0.1*randn(size(x));

f = fit(x',y','a*exp(b*x)','StartPoint',[1,-0.5]);

plot(f,x,y,'ro');
title('指数曲线拟合');