function I = romberg_int(f, a, b, tol, maxLevel)
% 龙贝格积分（Romberg），基于递推梯形+Richardson外推
if nargin<4, tol = 1e-10; end
if nargin<5, maxLevel = 10; end

R = zeros(maxLevel, maxLevel);
R(1,1) = 0.5*(b-a)*(f(a)+f(b));
for k = 2:maxLevel
    n  = 2^(k-1); h = (b-a)/n;
    % 只需新增奇点求值
    s = 0;
    for i = 1:2^(k-2)
        s = s + f(a + (2*i-1)*h);
    end
    R(k,1) = 0.5*R(k-1,1) + h*s;
    for j = 2:k
        R(k,j) = R(k,j-1) + (R(k,j-1)-R(k-1,j-1)) / (4^(j-1)-1);
    end
    if abs(R(k,k) - R(k-1,k-1)) < tol
        I = R(k,k); return;
    end
end
I = R(maxLevel, maxLevel);
end