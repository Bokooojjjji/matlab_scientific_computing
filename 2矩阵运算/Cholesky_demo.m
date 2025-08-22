% Cholesky_demo.m
% 演示 Cholesky 分解（适用于对称正定矩阵）

clc; clear; close all;

% 定义一个对称正定矩阵
A = [25, 15, -5; 15, 18,  0; -5, 0, 11];

% Cholesky 分解 A = R' * R
R = chol(A);

disp('Cholesky 分解结果：');
disp('上三角矩阵 R:');
disp(R);

% 验证分解是否正确
disp('R''*R = ');
disp(R' * R);
