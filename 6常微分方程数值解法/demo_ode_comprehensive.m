% demo_ode_comprehensive.m
% 常微分方程数值解法综合演示
% 包含：欧拉法、改进欧拉法、RK4、ode45、ode15s

clc; clear; close all;

%% 问题定义
% 测试问题集合
problems = struct();

% 问题1：一阶线性方程 dy/dx = -2y + sin(x)
problems(1).name = '一阶线性方程';
problems(1).f = @(x,y) -2*y + sin(x);
problems(1).exact = @(x) exp(-2*x) + (2*sin(x) - cos(x))/5;
problems(1).y0 = 0.8;
problems(1).tspan = [0 5];
problems(1).h = 0.1;

% 问题2：二阶系统 - 阻尼振动
problems(2).name = '阻尼振动系统';
problems(2).f = @(t,y) [y(2); -0.5*y(2) - 4*y(1)];
problems(2).exact = []; % 无解析解
problems(2).y0 = [1; 0];
problems(2).tspan = [0 10];
problems(2).h = 0.05;

% 问题3：非线性方程 - Logistic增长
problems(3).name = 'Logistic增长';
problems(3).f = @(t,y) 0.5*y*(1 - y/10);
problems(3).exact = @(t) 10./(1 + (10/0.5 - 1)*exp(-0.5*t));
problems(3).y0 = 0.5;
problems(3).tspan = [0 10];
problems(3).h = 0.2;

%% 数值解法实现
% 自定义数值方法
methods = struct();
methods(1).name = '欧拉法';
methods(1).func = @euler_ode;
methods(2).name = '改进欧拉法';
methods(2).func = @heun_ode;
methods(3).name = 'RK4';
methods(3).func = @rk4_ode;
methods(4).name = 'ode45';
methods(4).func = @(f,tspan,y0,h) ode45(f,tspan,y0);
methods(5).name = 'ode15s';
methods(5).func = @(f,tspan,y0,h) ode15s(f,tspan,y0);

%% 主计算循环
for p = 1:length(problems)
    problem = problems(p);
    fprintf('\n正在计算问题 %d: %s\n', p, problem.name);
    
    figure('Position', [100, 100, 1400, 1000]);
    
    % 存储结果
    results = struct();
    
    % 计算各种方法的解
    for m = 1:length(methods)
        method = methods(m);
        fprintf('  使用 %s...', method.name);
        
        try
            if m <= 3  % 自定义方法
                [t, y] = method.func(problem.f, problem.tspan, problem.y0, problem.h);
            else  % MATLAB内置方法
                [t, y] = method.func(problem.f, problem.tspan, problem.y0);
            end
            
            results(m).t = t;
            results(m).y = y;
            results(m).method = method.name;
            results(m).success = true;
            results(m).nsteps = length(t);
            
            fprintf(' 成功 (%d 步)\n', length(t));
            
        catch ME
            results(m).success = false;
            fprintf(' 失败: %s\n', ME.message);
        end
    end
    
    %% 结果可视化
    
    % 子图1：解的对比
    subplot(3,3,1);
    hold on;
    colors = ['r', 'g', 'b', 'm', 'c'];
    
    for m = 1:length(results)
        if results(m).success
            if isscalar(problem.y0)
                plot(results(m).t, results(m).y, [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
            else
                plot(results(m).t, results(m).y(:,1), [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
            end
        end
    end
    
    % 如果有精确解，添加精确解
    if ~isempty(problem.exact)
        t_exact = linspace(problem.tspan(1), problem.tspan(2), 1000);
        y_exact = problem.exact(t_exact);
        plot(t_exact, y_exact, 'k--', 'LineWidth', 2, 'DisplayName', '精确解');
    end
    
    xlabel('t'); ylabel('y'); title([problem.name, ' - 解对比']);
    legend('Location', 'best'); grid on;
    
    % 子图2：误差分析（如果有精确解）
    subplot(3,3,2);
    if ~isempty(problem.exact)
        hold on;
        for m = 1:length(results)
            if results(m).success && results(m).method ~= 'ode45' && results(m).method ~= 'ode15s'
                y_exact_interp = problem.exact(results(m).t);
                error = abs(results(m).y - y_exact_interp);
                semilogy(results(m).t, error, [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
            end
        end
        xlabel('t'); ylabel('绝对误差'); title('误差分析');
        legend('Location', 'best'); grid on;
    else
        title('无精确解 - 误差分析不可用');
        axis off;
    end
    
    % 子图3：计算效率
    subplot(3,3,3);
    methods_success = {};
    nsteps = [];
    for m = 1:length(results)
        if results(m).success
            methods_success{end+1} = results(m).method;
            nsteps(end+1) = results(m).nsteps;
        end
    end
    
    bar(nsteps);
    set(gca, 'XTickLabel', methods_success);
    ylabel('步数'); title('计算效率对比');
    
    % 子图4-6：相空间分析（对于系统）
    if ~isscalar(problem.y0)
        subplot(3,3,4);
        hold on;
        for m = 1:length(results)
            if results(m).success
                plot(results(m).y(:,1), results(m).y(:,2), [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
            end
        end
        xlabel('y_1'); ylabel('y_2'); title('相空间轨迹');
        legend('Location', 'best'); grid on;
        
        subplot(3,3,5);
        hold on;
        for m = 1:length(results)
            if results(m).success
                plot(results(m).t, results(m).y(:,2), [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
            end
        end
        xlabel('t'); ylabel('y_2'); title('速度随时间变化');
        legend('Location', 'best'); grid on;
    end
    
    % 子图7：能量分析（对于振动系统）
    if contains(problem.name, '振动')
        subplot(3,3,6);
        hold on;
        for m = 1:length(results)
            if results(m).success
                energy = 0.5 * (results(m).y(:,1).^2 + results(m).y(:,2).^2);
                plot(results(m).t, energy, [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
            end
        end
        xlabel('t'); ylabel('能量'); title('能量守恒分析');
        legend('Location', 'best'); grid on;
    end
    
    % 子图8：收敛性研究
    subplot(3,3,7);
    if ~isempty(problem.exact)
        h_values = [problem.h, problem.h/2, problem.h/4];
        errors = [];
        
        for h_idx = 1:length(h_values)
            [t_test, y_test] = euler_ode(problem.f, problem.tspan, problem.y0, h_values(h_idx));
            y_exact_test = problem.exact(t_test);
            errors(end+1) = max(abs(y_test - y_exact_test));
        end
        
        loglog(h_values, errors, 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
        hold on;
        loglog(h_values, errors(1)*(h_values/h_values(1)).^1, 'r--', 'DisplayName', 'O(h)');
        
        [t_test, y_test] = heun_ode(problem.f, problem.tspan, problem.y0, h_values(1));
        y_exact_test = problem.exact(t_test);
        error_heun = max(abs(y_test - y_exact_test));
        loglog(h_values, error_heun*(h_values/h_values(1)).^2, 'g--', 'DisplayName', 'O(h^2)');
        
        xlabel('步长 h'); ylabel('最大误差'); title('收敛性研究');
        legend('Location', 'best'); grid on;
    else
        title('收敛性研究 - 需要精确解');
        axis off;
    end
    
    % 子图9：方法总结
    subplot(3,3,8);
    summary_text = sprintf(['方法总结：\n' ...
        '欧拉法：O(h)精度，简单稳定\n' ...
        '改进欧拉：O(h^2)精度，预测-校正\n' ...
        'RK4：O(h^4)精度，高精度首选\n' ...
        'ode45：自适应步长，通用推荐\n' ...
        'ode15s：刚性方程专用']);
    text(0.5, 0.5, summary_text, 'FontSize', 12, 'HorizontalAlignment', 'center');
    axis off;
    
    sgtitle(['常微分方程数值解法 - ', problem.name], 'FontSize', 16);
end

%% 最终总结
fprintf('\n\n===== 数值方法总结 =====\n');
fprintf('1. 欧拉法：简单但精度低，适合教学\n');
fprintf('2. 改进欧拉法：精度提高，计算量增加\n');
fprintf('3. RK4：高精度，适合光滑解\n');
fprintf('4. ode45：自适应步长，非刚性首选\n');
fprintf('5. ode15s：刚性方程专用，效率最高\n');