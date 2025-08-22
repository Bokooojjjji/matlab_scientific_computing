% demo_stiff_equations.m
% 刚性方程演示：ode45 vs ode15s 对比

clc; clear; close all;

%% 定义刚性方程组
% 示例1：Van der Pol 振荡器
mu_values = [1, 10, 100, 1000];
colors = ['r', 'g', 'b', 'm'];

figure('Position', [100, 100, 1400, 1000]);

for idx = 1:length(mu_values)
    mu = mu_values(idx);
    
    % Van der Pol 方程
    vdp = @(t,y) [y(2); mu*(1-y(1)^2)*y(2) - y(1)];
    y0 = [2; 0];
    
    % 对于不同的mu值，调整时间区间
    if mu <= 10
        tspan = [0 20];
    elseif mu <= 100
        tspan = [0 5];
    else
        tspan = [0 1];
    end
    
    % 子图1：ode45 解
    subplot(4,4,idx);
    opts45 = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
    tic;
    [t45, y45] = ode45(vdp, tspan, y0, opts45);
    time45 = toc;
    
    plot(t45, y45(:,1), colors(idx), 'LineWidth', 1.5);
    xlabel('t'); ylabel('y_1'); title(['μ=', num2str(mu), ', ode45']);
    grid on;
    
    % 子图2：ode15s 解
    subplot(4,4,idx+4);
    opts15s = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
    tic;
    [t15s, y15s] = ode15s(vdp, tspan, y0, opts15s);
    time15s = toc;
    
    plot(t15s, y15s(:,1), colors(idx), 'LineWidth', 1.5);
    xlabel('t'); ylabel('y_1'); title(['μ=', num2str(mu), ', ode15s']);
    grid on;
    
    % 子图3：相空间轨迹
    subplot(4,4,idx+8);
    plot(y45(:,1), y45(:,2), [colors(idx), '-'], 'LineWidth', 1.5, 'DisplayName', 'ode45');
    hold on;
    plot(y15s(:,1), y15s(:,2), [colors(idx), '--'], 'LineWidth', 1.5, 'DisplayName', 'ode15s');
    xlabel('y_1'); ylabel('y_2'); title(['μ=', num2str(mu), ', 相空间']);
    legend('Location', 'best'); grid on;
    
    % 子图4：计算效率对比
    subplot(4,4,idx+12);
    bar([length(t45), length(t15s)]);
    set(gca, 'XTickLabel', {'ode45', 'ode15s'});
    ylabel('步数'); title(['μ=', num2str(mu), ', 效率']);
    
    % 在命令窗口显示结果
    fprintf('μ=%d: ode45步数=%d, 时间=%.4fs; ode15s步数=%d, 时间=%.4fs\n', ...
            mu, length(t45), time45, length(t15s), time15s);
end

%% 示例2：化学反应刚性系统
% Robertson 化学反应模型
robertson = @(t,y) [-0.04*y(1) + 1e4*y(2)*y(3);
                    0.04*y(1) - 1e4*y(2)*y(3) - 3e7*y(2)^2;
                    3e7*y(2)^2];

y0_rob = [1; 0; 0];
tspan_rob = [0 1e4];

figure('Position', [100, 100, 1200, 800]);

% 使用ode45
subplot(2,3,1);
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
[t45_rob, y45_rob] = ode45(robertson, tspan_rob, y0_rob, opts);
semilogx(t45_rob, y45_rob);
xlabel('时间'); ylabel('浓度'); title('ode45: Robertson 反应');
legend('y_1', 'y_2', 'y_3'); grid on;

% 使用ode15s
subplot(2,3,2);
[t15s_rob, y15s_rob] = ode15s(robertson, tspan_rob, y0_rob, opts);
semilogx(t15s_rob, y15s_rob);
xlabel('时间'); ylabel('浓度'); title('ode15s: Robertson 反应');
legend('y_1', 'y_2', 'y_3'); grid on;

% 计算效率对比
subplot(2,3,3);
bar([length(t45_rob), length(t15s_rob)]);
set(gca, 'XTickLabel', {'ode45', 'ode15s'});
ylabel('步数'); title('计算效率对比');

% 组分随时间变化
subplot(2,3,4);
loglog(t45_rob, y45_rob(:,1), 'r-', 'DisplayName', 'y_1 (ode45)');
hold on;
loglog(t15s_rob, y15s_rob(:,1), 'r--', 'DisplayName', 'y_1 (ode15s)');
loglog(t45_rob, y45_rob(:,2), 'g-', 'DisplayName', 'y_2 (ode45)');
loglog(t15s_rob, y15s_rob(:,2), 'g--', 'DisplayName', 'y_2 (ode15s)');
loglog(t45_rob, y45_rob(:,3), 'b-', 'DisplayName', 'y_3 (ode45)');
loglog(t15s_rob, y15s_rob(:,3), 'b--', 'DisplayName', 'y_3 (ode15s)');
xlabel('时间'); ylabel('浓度'); title('组分浓度对比');
legend('Location', 'best'); grid on;

% 误差分析
subplot(2,3,5);
y1_interp = interp1(t15s_rob, y15s_rob(:,1), t45_rob);
y2_interp = interp1(t15s_rob, y15s_rob(:,2), t45_rob);
y3_interp = interp1(t15s_rob, y15s_rob(:,3), t45_rob);

error1 = abs(y45_rob(:,1) - y1_interp);
error2 = abs(y45_rob(:,2) - y2_interp);
error3 = abs(y45_rob(:,3) - y3_interp);

loglog(t45_rob, error1, 'r-', 'DisplayName', 'y_1 误差');
hold on;
loglog(t45_rob, error2, 'g-', 'DisplayName', 'y_2 误差');
loglog(t45_rob, error3, 'b-', 'DisplayName', 'y_3 误差');
xlabel('时间'); ylabel('绝对误差'); title('ode45 vs ode15s 误差');
legend('Location', 'best'); grid on;

%% 总结
subplot(2,3,6);
text(0.5, 0.8, '刚性方程特点：', 'FontSize', 14, 'HorizontalAlignment', 'center');
text(0.5, 0.6, '• 存在不同时间尺度', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(0.5, 0.5, '• 显式方法需要极小步长', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(0.5, 0.4, '• 隐式方法更高效', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(0.5, 0.2, 'ode15s 适用于刚性系统', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
axis off;

fprintf('\n总结：\n');
fprintf('1. 对于非刚性问题，ode45通常更高效\n');
fprintf('2. 对于刚性问题，ode15s显著减少计算量\n');
fprintf('3. 刚性程度越高，ode15s的优势越明显\n');