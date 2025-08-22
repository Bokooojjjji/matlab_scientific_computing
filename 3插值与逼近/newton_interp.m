% newton_interp.m
% 使用 Newton 插值（差商）

clc; clear; close all;

% 插值节点
x = [1, 2, 3, 4];
y = [1, 4, 9, 16]; % y = x^2

n = length(x);

% 构造差商表
diff_table = zeros(n, n);
diff_table(:,1) = y';

for j = 2:n
    for i = 1:(n-j+1)
        diff_table(i,j) = (diff_table(i+1,j-1) - diff_table(i,j-1)) / (x(i+j-1)-x(i));
    end
end

disp('差商表:');
disp(diff_table);

% 插值函数
xx = linspace(1,4,100);
yy = zeros(size(xx));

for k = 1:length(xx)
    s = diff_table(1,1);
    prod_term = 1;
    for j = 1:n-1
        prod_term = prod_term * (xx(k)-x(j));
        s = s + diff_table(1,j+1)*prod_term;
    end
    yy(k) = s;
end

plot(x, y, 'ro', 'MarkerFaceColor','r');
hold on;
plot(xx, yy, 'b-', 'LineWidth', 1.5);
title('Newton 插值');
legend('节点','插值曲线');