% demo_classical_problems.m
% 经典ODE问题的数值解法演示

clc; clear; close all;

%% 经典问题定义
problems = struct();

% 1. 简谐振子：y'' + y = 0
problems(1).name = '简谐振子';
problems(1).f = @(t,y) [y(2); -y(1)];
problems(1).y0 = [1; 0];
problems(1).tspan = [0 4*pi];
problems(1).h = 0.1;
problems(1).exact = @(t) [cos(t); -sin(t)];

% 2. 阻尼振动：y'' + 0.5y' + 4y = 0
problems(2).name = '阻尼振动';
problems(2).f = @(t,y) [y(2); -0.5*y(2) - 4*y(1)];
problems(2).y0 = [1; 0];
problems(2).tspan = [0 10];
problems(2).h = 0.05;
problems(2).exact = [];

% 3. 范德波尔振荡器：y'' - μ(1-y^2)y' + y = 0
problems(3).name = '范德波尔振荡器';
problems(3).mu = 1;
problems(3).f = @(t,y) [y(2); problems(3).mu*(1-y(1)^2)*y(2) - y(1)];
problems(3).y0 = [0.5; 0];
problems(3).tspan = [0 20];
problems(3).h = 0.05;
problems(3).exact = [];

% 4. 洛伦兹系统
problems(4).name = '洛伦兹系统';
problems(4).sigma = 10; problems(4).rho = 28; problems(4).beta = 8/3;
problems(4).f = @(t,y) [problems(4).sigma*(y(2)-y(1)); ...
                       y(1)*(problems(4).rho-y(3))-y(2); ...
                       y(1)*y(2)-problems(4).beta*y(3)];
problems(4).y0 = [1; 1; 1];
problems(4).tspan = [0 30];
problems(4).h = 0.01;
problems(4).exact = [];

% 5. 捕食者-猎物系统（Lotka-Volterra）
problems(5).name = '捕食者-猎物系统';
problems(5).a = 1; problems(5).b = 0.1; problems(5).c = 1.5; problems(5).d = 0.075;
problems(5).f = @(t,y) [problems(5).a*y(1) - problems(5).b*y(1)*y(2); ...
                       -problems(5).c*y(2) + problems(5).d*y(1)*y(2)];
problems(5).y0 = [10; 5];
problems(5).tspan = [0 15];
problems(5).h = 0.05;
problems(5).exact = [];

%% 数值方法
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

%% 计算和可视化
for p = 1:length(problems)
    problem = problems(p);
    fprintf('\n计算问题: %s\n', problem.name);
    
    figure('Position', [100, 100, 1600, 1200]);
    
    % 存储结果
    results = struct();
    
    % 计算各种方法的解
    for m = 1:length(methods)
        method = methods(m);
        fprintf('  %s...', method.name);
        
        try
            if m <= 3  % 自定义方法
                [t, y] = method.func(problem.f, problem.tspan, problem.y0, problem.h);
            else  % MATLAB内置方法
                [t, y] = method.func(problem.f, problem.tspan, problem.y0, problem.h);
            end
            
            results(m).t = t;
            results(m).y = y;
            results(m).method = method.name;
            results(m).success = true;
            results(m).nsteps = length(t);
            
            fprintf(' 成功 (%d步)\n', length(t));
            
        catch
            results(m).success = false;
            fprintf(' 失败\n');
        end
    end
    
    %% 结果可视化
    
    % 子图1：时间序列
    subplot(4,3,1);
    hold on;
    colors = ['r', 'g', 'b', 'm', 'c'];
    
    for m = 1:length(results)
        if results(m).success
            if size(results(m).y, 2) == 1
                plot(results(m).t, results(m).y, [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
            else
                plot(results(m).t, results(m).y(:,1), [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
            end
        end
    end
    
    if ~isempty(problem.exact)
        t_exact = linspace(problem.tspan(1), problem.tspan(2), 1000);
        y_exact = problem.exact(t_exact);
        if size(y_exact, 1) == 2
            plot(t_exact, y_exact(1,:), 'k--', 'LineWidth', 2, 'DisplayName', '精确解');
        else
            plot(t_exact, y_exact, 'k--', 'LineWidth', 2, 'DisplayName', '精确解');
        end
    end
    
    xlabel('时间 t'); ylabel('y'); title([problem.name, ' - 时间序列']);
    legend('Location', 'best'); grid on;
    
    % 子图2：相空间轨迹（对于系统）
    if size(problem.y0, 1) > 1
        subplot(4,3,2);
        hold on;
        for m = 1:length(results)
            if results(m).success
                plot(results(m).y(:,1), results(m).y(:,2), [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
            end
        end
        xlabel('y_1'); ylabel('y_2'); title('相空间轨迹');
        legend('Location', 'best'); grid on; axis equal;
        
        % 子图3：3D轨迹（对于三维系统）
        if size(problem.y0, 1) == 3
            subplot(4,3,3);
            hold on;
            for m = 1:length(results)
                if results(m).success
                    plot3(results(m).y(:,1), results(m).y(:,2), results(m).y(:,3), ...
                         [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
                end
            end
            xlabel('x'); ylabel('y'); zlabel('z'); title('3D轨迹');
            legend('Location', 'best'); grid on; view(3);
        end
    end
    
    % 子图4：误差分析（有精确解时）
    subplot(4,3,4);
    if ~isempty(problem.exact) && size(problem.y0, 1) == 1
        hold on;
        for m = 1:length(results)
            if results(m).success && results(m).method ~= 'ode45' && results(m).method ~= 'ode15s'
                y_exact = problem.exact(results(m).t);
                error = abs(results(m).y - y_exact);
                semilogy(results(m).t, error, [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
            end
        end
        xlabel('t'); ylabel('绝对误差'); title('误差分析');
        legend('Location', 'best'); grid on;
    end
    
    % 子图5：计算效率
    subplot(4,3,5);
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
    
    % 子图6：收敛性研究
    subplot(4,3,6);
    if ~isempty(problem.exact) && size(problem.y0, 1) == 1
        h_values = [problem.h, problem.h/2, problem.h/4, problem.h/8];
        errors_euler = [];
        errors_heun = [];
        errors_rk4 = [];
        
        for h = h_values
            [t_euler, y_euler] = euler_ode(problem.f, problem.tspan, problem.y0, h);
            [t_heun, y_heun] = heun_ode(problem.f, problem.tspan, problem.y0, h);
            [t_rk4, y_rk4] = rk4_ode(problem.f, problem.tspan, problem.y0, h);
            
            errors_euler(end+1) = max(abs(y_euler - problem.exact(t_euler)));
            errors_heun(end+1) = max(abs(y_heun - problem.exact(t_heun)));
            errors_rk4(end+1) = max(abs(y_rk4 - problem.exact(t_rk4)));
        end
        
        loglog(h_values, errors_euler, 'ro-', 'LineWidth', 2, 'DisplayName', '欧拉法');
        hold on;
        loglog(h_values, errors_heun, 'go-', 'LineWidth', 2, 'DisplayName', '改进欧拉');
        loglog(h_values, errors_rk4, 'bo-', 'LineWidth', 2, 'DisplayName', 'RK4');
        
        % 添加参考线
        loglog(h_values, errors_euler(1)*(h_values/h_values(1)).^1, 'r--', 'DisplayName', 'O(h)');
        loglog(h_values, errors_heun(1)*(h_values/h_values(1)).^2, 'g--', 'DisplayName', 'O(h^2)');
        loglog(h_values, errors_rk4(1)*(h_values/h_values(1)).^4, 'b--', 'DisplayName', 'O(h^4)');
        
        xlabel('步长 h'); ylabel('最大误差'); title('收敛性研究');
        legend('Location', 'best'); grid on;
    end
    
    % 子图7-9：特定问题分析
    switch p
        case 1  % 简谐振子
            subplot(4,3,7);
            hold on;
            for m = 1:length(results)
                if results(m).success
                    energy = 0.5 * (results(m).y(:,1).^2 + results(m).y(:,2).^2);
                    plot(results(m).t, energy, [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
                end
            end
            xlabel('t'); ylabel('能量'); title('能量守恒分析');
            legend('Location', 'best'); grid on;
            
        case 3  % 范德波尔振荡器
            subplot(4,3,7);
            hold on;
            for m = 1:length(results)
                if results(m).success
                    plot(results(m).y(:,1), results(m).y(:,2), [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
                end
            end
            xlabel('y'); ylabel('y'''); title('极限环');
            legend('Location', 'best'); grid on; axis equal;
            
        case 4  % 洛伦兹系统
            subplot(4,3,7);
            hold on;
            for m = 1:length(results)
                if results(m).success
                    plot3(results(m).y(:,1), results(m).y(:,2), results(m).y(:,3), ...
                         [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
                end
            end
            xlabel('x'); ylabel('y'); zlabel('z'); title('洛伦兹吸引子');
            legend('Location', 'best'); grid on; view(45, 30);
            
        case 5  % 捕食者-猎物系统
            subplot(4,3,7);
            hold on;
            for m = 1:length(results)
                if results(m).success
                    plot(results(m).y(:,1), results(m).y(:,2), [colors(m), '-'], 'LineWidth', 1.5, 'DisplayName', results(m).method);
                end
            end
            xlabel('猎物'); ylabel('捕食者'); title('相平面轨迹');
            legend('Location', 'best'); grid on; axis equal;
    end
    
    % 子图8：方法特性总结
    subplot(4,3,8);
    summary_text = sprintf(['数值方法特性：\n\n' ...
        '欧拉法：O(h)精度，简单稳定\n' ...
        '改进欧拉：O(h^2)精度，预测-校正\n' ...
        'RK4：O(h^4)精度，高精度首选\n' ...
        'ode45：自适应步长，通用推荐\n' ...
        'ode15s：刚性方程专用']);
    text(0.5, 0.5, summary_text, 'FontSize', 11, 'HorizontalAlignment', 'center');
    axis off;
    
    sgtitle(['经典ODE问题 - ', problem.name], 'FontSize', 16);
end

%% 最终总结
fprintf('\n\n===== 经典ODE问题总结 =====\n');
fprintf('1. 简谐振子：测试能量守恒和周期性\n');
fprintf('2. 阻尼振动：研究衰减行为\n');
fprintf('3. 范德波尔：非线性极限环\n');
fprintf('4. 洛伦兹系统：混沌动力学\n');
fprintf('5. 捕食者-猎物：生态动力学\n');