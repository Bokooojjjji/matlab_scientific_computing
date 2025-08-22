function [x,y,U,it] = laplace2d_gs(nx,ny, gL,gR,gB,gT, tol, maxit)
% 单位方形 [0,1]x[0,1]，Dirichlet 边界:
% 左 gL(y), 右 gR(y), 下 gB(x), 上 gT(x)
if nargin<7, tol=1e-6; end
if nargin<8, maxit=50000; end
x = linspace(0,1,nx); y= linspace(0,1,ny);
U = zeros(ny,nx);
% 设定边界
U(:,1)   = arrayfun(gL, y).';
U(:,end) = arrayfun(gR, y).';
U(1,:)   = arrayfun(gB, x);
U(end,:) = arrayfun(gT, x);

for it=1:maxit
    Uold = U;
    for j=2:ny-1
        for i=2:nx-1
            U(j,i) = 0.25*( U(j,i-1)+U(j,i+1)+U(j-1,i)+U(j+1,i) );
        end
    end
    if norm(U-Uold,'fro')/max(1,norm(U,'fro')) < tol, break; end
end
end