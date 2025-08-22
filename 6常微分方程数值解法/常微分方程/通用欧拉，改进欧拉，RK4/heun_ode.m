function [t,Y] = heun_ode(f, tspan, y0, h)
% 改进欧拉（Heun）：预测-校正
t = (tspan(1):h:tspan(2))'; m=numel(t); y0=y0(:); d=numel(y0);
Y = zeros(m,d); Y(1,:)=y0.';
for k=1:m-1
    yk = Y(k,:).'; tk=t(k);
    k1 = f(tk, yk);
    k2 = f(tk+h, yk + h*k1);
    Y(k+1,:) = (yk + 0.5*h*(k1+k2)).';
end
end