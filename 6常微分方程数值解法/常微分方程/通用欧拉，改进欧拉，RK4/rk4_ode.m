function [t,Y] = rk4_ode(f, tspan, y0, h)
t = (tspan(1):h:tspan(2))'; m=numel(t); y0=y0(:); d=numel(y0);
Y = zeros(m,d); Y(1,:)=y0.';
for k=1:m-1
    tk=t(k); yk=Y(k,:).';
    k1 = f(tk, yk);
    k2 = f(tk+h/2, yk + h*k1/2);
    k3 = f(tk+h/2, yk + h*k2/2);
    k4 = f(tk+h,   yk + h*k3);
    Y(k+1,:) = (yk + h/6*(k1 + 2*k2 + 2*k3 + k4)).';
end
end