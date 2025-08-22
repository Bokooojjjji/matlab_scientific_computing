% lagrange_interp.m
% 使用 Lagrange 插值构造插值多项式

clc; clear; close all;

% 定义插值节点
x = [0, 1, 2, 3];
y = [1, 2, 0, 4];

% 定义待插值点
xx = linspace(0, 3, 100);
yy = zeros(size(xx));

n = length(x);

% Lagrange 插值公式
for k = 1:length(xx)
    s = 0;
    for i = 1:n
        L = 1;
        for j = 1:n
            if i ~= j
                L = L * (xx(k)-x(j)) / (x(i)-x(j));
            end
        end
        s = s + y(i) * L;
    end
    yy(k) = s;
end

plot(x, y, 'ro', 'MarkerFaceColor','r');
hold on;
plot(xx, yy, 'b-', 'LineWidth', 1.5);
title('Lagrange 插值');
legend('节点','插值曲线');