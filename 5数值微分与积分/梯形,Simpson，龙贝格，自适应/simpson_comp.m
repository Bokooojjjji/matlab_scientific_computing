function I = simpson_comp(f, a, b, n)
% 复合 Simpson（n 必须为偶数）
if mod(n,2)~=0, error('n 必须为偶数'); end
h = (b-a)/n;
x = a:h:b; y = f(x);
I = h/3*( y(1)+y(end) + 4*sum(y(2:2:end-1)) + 2*sum(y(3:2:end-2)) );
end