function [x,t,U] = heat1d_cn(alpha, L, T, nx, nt, ic, ua, ub)
dx=L/nx; dt=T/nt; r=alpha*dt/dx^2;
x=linspace(0,L,nx+1); t=linspace(0,T,nt+1);
U=zeros(nt+1,nx+1); U(1,:)=ic(x); U(:,1)=ua; U(:,end)=ub;

e = ones(nx-1,1);
A = spdiags([-r/2*e, (1+r)*e, -r/2*e], -1:1, nx-1, nx-1);
B = spdiags([ r/2*e, (1-r)*e,  r/2*e], -1:1, nx-1, nx-1);

for n=1:nt
    rhs = B*U(n,2:end-1).';
    % 边界修正
    rhs(1)   = rhs(1)   + r/2*(U(n,1)+U(n+1,1));
    rhs(end) = rhs(end) + r/2*(U(n,end)+U(n+1,end));
    U(n+1,2:end-1) = (A \ rhs).';
end
end