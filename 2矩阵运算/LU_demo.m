% LU_demo.m
% 演示 LU 分解并解线性方程组 Ax=b

clc; clear; close all;

% 定义一个矩阵 A 和向量 b
A = [4, -2, 1; -2, 4, -2; 1, -2, 3];
b = [1; 4; 2];

% 使用 MATLAB 内置函数 lu 进行 LU 分解
[L, U, P] = lu(A);

disp('矩阵 A 的 LU 分解结果：');
disp('置换矩阵 P:'); disp(P);
disp('下三角矩阵 L:'); disp(L);
disp('上三角矩阵 U:'); disp(U);

% 解方程组 Ax=b
y = L \ (P*b);
x = U \ y;

disp('解方程组 Ax=b 的结果：');
disp(x);