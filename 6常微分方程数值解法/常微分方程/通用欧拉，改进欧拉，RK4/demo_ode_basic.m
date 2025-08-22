f = @(t,y) [y(2); -y(1)]; % 简谐振子 y''+y=0
[t1,Y1]=euler_ode(f,[0 10],[1;0],0.01);
[t2,Y2]=rk4_ode(f,[0 10],[1;0],0.01);
plot(t1,Y1(:,1),'r--', t2,Y2(:,1),'b-'); legend('Euler','RK4'); title('ODE 对比');