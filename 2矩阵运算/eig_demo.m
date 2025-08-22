% eig_demo.m
% 演示 MATLAB 计算特征值与特征向量

clc; clear; close all;

% 定义矩阵
A = [2, 1, 0; 1, 2, 1; 0, 1, 2];

% 计算特征值和特征向量
[V, D] = eig(A);

disp('特征值矩阵 D:');
disp(D);
disp('特征向量矩阵 V:');
disp(V);

% 验证 A*V = V*D
disp('验证 A*V 与 V*D 是否相等：');
disp(A*V);
disp(V*D);