function [x,t,U] = wave1d_explicit(c, L, T, nx, nt, ic, vc, ul, ur)
% 边界: u(0,t)=ul, u(L,t)=ur; 初值: u(x,0)=ic(x), u_t(x,0)=vc(x)
dx=L/nx; dt=T/nt; r=c*dt/dx;
if r>1, warning('CFL 条件 r<=1，目前 r=%.3f', r); end
x=linspace(0,L,nx+1); t=linspace(0,T,nt+1);
U=zeros(nt+1,nx+1); U(1,:)=ic(x); U(:,1)=ul; U(:,end)=ur;

% 第一步用 Taylor 展开
U(2,2:end-1) = U(1,2:end-1) + dt*vc(x(2:end-1)) + ...
               0.5*r^2*( U(1,3:end)-2*U(1,2:end-1)+U(1,1:end-2) );

for n=2:nt
    U(n+1,2:end-1) = 2*(1-r^2)*U(n,2:end-1) - U(n-1,2:end-1) + ...
                      r^2*(U(n,3:end) + U(n,1:end-2));
end
end