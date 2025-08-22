function p = polyfit_ls(x, y, n)
% 多项式最小二乘拟合：拟合 y ≈ p0 + p1 x + ... + pn x^n
% 返回 p 为 polyval 兼容的“降幂系数” [pn ... p1 p0]
% 采用 QR 分解（更稳定），避免直接求法方程。
x = x(:); y = y(:);
m = numel(x);
if m < n+1, error('数据点不足，至少需要 n+1 个点'); end

% 构造 Vandermonde（升幂），再翻转成降幂
Vasc = zeros(m, n+1);
for k = 0:n
    Vasc(:, k+1) = x.^k;
end

% 最小二乘：min ||Vasc*c - y||，用 QR 解
[Q, R] = qr(Vasc, 0);
c_asc = R \ (Q' * y);   % 升幂系数 c0..cn
p = flipud(c_asc);      % 转成降幂 [cn..c0]，polyval 兼容
end