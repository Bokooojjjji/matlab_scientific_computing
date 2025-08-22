function [x,t,U] = heat1d_explicit(alpha, L, T, nx, nt, ic, ua, ub)
% 0<=x<=L, 0<=t<=T, Dirichlet: u(0,t)=ua, u(L,t)=ub
dx = L/nx; dt = T/nt; r = alpha*dt/dx^2;
if r>0.5, warning('显式格式稳定性要求 r<=0.5，目前 r=%.3f', r); end
x = linspace(0,L,nx+1); t = linspace(0,T,nt+1);
U = zeros(nt+1, nx+1);
U(1,:) = ic(x);
U(:,1) = ua; U(:,end) = ub;
for n = 1:nt
    U(n+1,2:end-1) = U(n,2:end-1) + r*(U(n,3:end) - 2*U(n,2:end-1) + U(n,1:end-2));
end
end