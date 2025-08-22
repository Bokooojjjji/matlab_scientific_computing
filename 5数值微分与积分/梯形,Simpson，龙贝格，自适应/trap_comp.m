function I = trap_comp(f, a, b, n)
% 复合梯形积分（n 子区间）
h = (b-a)/n;
x = a:h:b; y = f(x);
I = h*(sum(y) - 0.5*(y(1)+y(end)));
end