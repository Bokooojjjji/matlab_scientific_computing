% demo_rk4_comparison.m
% RK4方法与欧拉法、改进欧拉法的详细对比演示

clc; clear; close all;

%% 定义测试问题
% 问题1：简谐振子 y'' + y = 0
f1 = @(t,y) [y(2); -y(1)];
y0_1 = [1; 0]; % 初始条件 [y(0), y'(0)] = [1, 0]
tspan_1 = [0 10];

% 问题2：非线性系统 - 洛伦兹吸引子
sigma = 10; rho = 28; beta = 8/3;
f2 = @(t,y) [sigma*(y(2)-y(1)); y(1)*(rho-y(3))-y(2); y(1)*y(2)-beta*y(3)];
y0_2 = [1; 1; 1];
tspan_2 = [0 20];

%% 问题1：简谐振子演示
figure('Position', [100, 100, 1400, 1000]);

% 使用通用函数计算
h1 = 0.1;
[t_euler, y_euler] = euler_ode(f1, tspan_1, y0_1, h1);
[t_heun, y_heun] = heun_ode(f1, tspan_1, y0_1, h1);
[t_rk4, y_rk4] = rk4_ode(f1, tspan_1, y0_1, h1);

% 子图1：位移随时间变化
subplot(3,2,1);
plot(t_euler, y_euler(:,1), 'r-', 'LineWidth', 1.5, 'DisplayName', '欧拉法');
hold on;
plot(t_heun, y_heun(:,1), 'g-', 'LineWidth', 1.5, 'DisplayName', '改进欧拉');
plot(t_rk4, y_rk4(:,1), 'b-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
plot(t_rk4, cos(t_rk4), 'k--', 'LineWidth', 2, 'DisplayName', '精确解 cos(t)');
xlabel('时间 t'); ylabel('位移 y'); title('简谐振子 - 位移');
legend('Location', 'best'); grid on;

% 子图2：相空间轨迹
subplot(3,2,2);
plot(y_euler(:,1), y_euler(:,2), 'r-', 'LineWidth', 1.5, 'DisplayName', '欧拉法');
hold on;
plot(y_heun(:,1), y_heun(:,2), 'g-', 'LineWidth', 1.5, 'DisplayName', '改进欧拉');
plot(y_rk4(:,1), y_rk4(:,2), 'b-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
plot(cos(t_rk4), -sin(t_rk4), 'k--', 'LineWidth', 2, 'DisplayName', '精确圆');
xlabel('位移 y'); ylabel('速度 y'''); title('相空间轨迹');
legend('Location', 'best'); grid on; axis equal;

% 子图3：能量守恒分析（简谐振子能量应为常数）
energy_euler = 0.5 * (y_euler(:,1).^2 + y_euler(:,2).^2);
energy_heun = 0.5 * (y_heun(:,1).^2 + y_heun(:,2).^2);
energy_rk4 = 0.5 * (y_rk4(:,1).^2 + y_rk4(:,2).^2);

subplot(3,2,3);
plot(t_euler, energy_euler, 'r-', 'LineWidth', 1.5, 'DisplayName', '欧拉法');
hold on;
plot(t_heun, energy_heun, 'g-', 'LineWidth', 1.5, 'DisplayName', '改进欧拉');
plot(t_rk4, energy_rk4, 'b-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
yline(0.5, 'k--', 'LineWidth', 2, 'DisplayName', '精确能量');
xlabel('时间 t'); ylabel('能量 E'); title('能量守恒分析');
legend('Location', 'best'); grid on;

%% 问题2：洛伦兹吸引子演示
h2 = 0.01;
[t_euler2, y_euler2] = euler_ode(f2, tspan_2, y0_2, h2);
[t_heun2, y_heun2] = heun_ode(f2, tspan_2, y0_2, h2);
[t_rk4_2, y_rk4_2] = rk4_ode(f2, tspan_2, y0_2, h2);

% 子图4：洛伦兹吸引子 - 3D轨迹
subplot(3,2,4);
plot3(y_euler2(:,1), y_euler2(:,2), y_euler2(:,3), 'r-', 'LineWidth', 1, 'DisplayName', '欧拉法');
hold on;
plot3(y_heun2(:,1), y_heun2(:,2), y_heun2(:,3), 'g-', 'LineWidth', 1, 'DisplayName', '改进欧拉');
plot3(y_rk4_2(:,1), y_rk4_2(:,2), y_rk4_2(:,3), 'b-', 'LineWidth', 1, 'DisplayName', 'RK4');
xlabel('x'); ylabel('y'); zlabel('z'); title('洛伦兹吸引子 - 3D轨迹');
legend('Location', 'best'); grid on; view(3);

% 子图5：洛伦兹吸引子 - XY平面投影
subplot(3,2,5);
plot(y_euler2(:,1), y_euler2(:,2), 'r.', 'MarkerSize', 1, 'DisplayName', '欧拉法');
hold on;
plot(y_heun2(:,1), y_heun2(:,2), 'g.', 'MarkerSize', 1, 'DisplayName', '改进欧拉');
plot(y_rk4_2(:,1), y_rk4_2(:,2), 'b.', 'MarkerSize', 1, 'DisplayName', 'RK4');
xlabel('x'); ylabel('y'); title('洛伦兹吸引子 - XY平面投影');
legend('Location', 'best'); grid on;

%% 精度分析
subplot(3,2,6);
% 使用ode45作为参考解
opts = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);
[t_ref, y_ref] = ode45(f1, tspan_1, y0_1, opts);

% 计算与参考解的误差
y_ref_interp = interp1(t_ref, y_ref(:,1), t_euler);
error_euler = abs(y_euler(:,1) - y_ref_interp);
error_heun = abs(y_heun(:,1) - interp1(t_ref, y_ref(:,1), t_heun));
error_rk4 = abs(y_rk4(:,1) - interp1(t_ref, y_ref(:,1), t_rk4));

loglog(t_euler, error_euler, 'r-', 'LineWidth', 1.5, 'DisplayName', '欧拉法误差');
hold on;
loglog(t_heun, error_heun, 'g-', 'LineWidth', 1.5, 'DisplayName', '改进欧拉误差');
loglog(t_rk4, error_rk4, 'b-', 'LineWidth', 1.5, 'DisplayName', 'RK4误差');
xlabel('时间 t'); ylabel('绝对误差'); title('精度对比（以ode45为参考）');
legend('Location', 'best'); grid on;

sgtitle('数值方法对比：欧拉法 vs 改进欧拉法 vs RK4', 'FontSize', 16);