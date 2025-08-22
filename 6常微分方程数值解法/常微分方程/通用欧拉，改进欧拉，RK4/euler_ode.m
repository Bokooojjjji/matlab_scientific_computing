function [t,Y] = euler_ode(f, tspan, y0, h)
% 显式欧拉
t = (tspan(1):h:tspan(2))'; m=numel(t); y0=y0(:); d=numel(y0);
Y = zeros(m,d); Y(1,:)=y0.';
for k=1:m-1
    Y(k+1,:)= (Y(k,:).' + h*f(t(k), Y(k,:).')).';
end
end