% 非刚性例子：Van der Pol (mu=1)
mu=1; f1=@(t,y)[y(2); mu*(1-y(1)^2)*y(2) - y(1)];
[t,y]=ode45(f1,[0 20],[2;0]); figure; plot(t,y(:,1)); title('ode45: Van der Pol (\mu=1)');

% 刚性例子：Van der Pol (mu=1000) 用 ode15s
mu=1000; f2=@(t,y)[y(2); mu*(1-y(1)^2)*y(2) - y(1)];
opts=odeset('RelTol',1e-6,'AbsTol',1e-8);
[t2,y2]=ode15s(f2,[0 1],[2;0],opts); figure; plot(t2,y2(:,1)); title('ode15s: Van der Pol (\mu=1000)');