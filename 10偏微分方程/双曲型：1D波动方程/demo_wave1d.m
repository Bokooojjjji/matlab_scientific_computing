ic=@(x) exp(-100*(x-0.5).^2); vc=@(x) 0; [x,t,U]=wave1d_explicit(1,1,1,200,400,ic,vc,0,0);
imagesc(x,t,U); colorbar; xlabel x; ylabel t; title('1D 波动方程 显式');