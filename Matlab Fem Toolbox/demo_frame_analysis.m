% demo_frame_analysis.m
% 框架结构有限元分析演示
% 包含多层框架和动力特性分析

clc; clear; close all;

%% 参数设置
E = 200e9;      % 弹性模量 (Pa)
I_col = 2e-4;   % 柱截面惯性矩 (m^4)
I_beam = 1e-4;  % 梁截面惯性矩 (m^4)
A_col = 0.02;   % 柱截面积 (m^2)
A_beam = 0.015; % 梁截面积 (m^2)

%% 案例1：单层单跨框架
fprintf('=== 案例1：单层单跨框架 ===\n');

% 节点坐标
nodes = [0 0; 0 3; 3 3; 3 0];
% 单元属性
elements(1).type = 'beam'; elements(1).nodes = [1 2]; elements(1).prop_id = 1; % 左柱
elements(2).type = 'beam'; elements(2).nodes = [2 3]; elements(2).prop_id = 2; % 横梁
elements(3).type = 'beam'; elements(3).nodes = [3 4]; elements(3).prop_id = 1; % 右柱

props(1).E = E; props(1).I = I_col; props(1).A = A_col;    % 柱属性
props(2).E = E; props(2).I = I_beam; props(2).A = A_beam;  % 梁属性

% 组装全局矩阵
[K,F,dofpn] = assemble_global(nodes, elements, props);

% 施加荷载：横梁均布荷载
for e = 1:length(elements)
    if strcmp(elements(e).type, 'beam')
        L = norm(nodes(elements(e).nodes(2),:) - nodes(elements(e).nodes(1),:));
        elements(e).udl = -5000; % 均布荷载 -5kN/m
    end
end

[K,F,dofpn] = assemble_global(nodes, elements, props);

% 边界条件：基础固定
fixedDofs = [1, 2, 3, 10, 11, 12];
[Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
U = Km \ Fm;

% 结果输出
fprintf('节点位移:\n');
fprintf('节点1: u=%.6f m, v=%.6f m, θ=%.6f rad\n', U(1), U(2), U(3));
fprintf('节点2: u=%.6f m, v=%.6f m, θ=%.6f rad\n', U(4), U(5), U(6));
fprintf('节点3: u=%.6f m, v=%.6f m, θ=%.6f rad\n', U(7), U(8), U(9));
fprintf('节点4: u=%.6f m, v=%.6f m, θ=%.6f rad\n', U(10), U(11), U(12));

% 内力计算
elemForces = postprocess_beam_forces(nodes, elements, props, U);

% 理论解对比（近似）
L_span = 3; L_height = 3;
M_beam_theory = 5000 * L_span^2 / 8;
V_col_theory = 5000 * L_span / 2;

fprintf('\n理论对比:\n');
fprintf('横梁最大弯矩: FEM=%.1f kN·m, 理论=%.1f kN·m\n', ...
        max(abs([elemForces(2).M1, elemForces(2).M2]))/1000, M_beam_theory/1000);
fprintf('柱端剪力: FEM=%.1f kN, 理论=%.1f kN\n', ...
        abs(elemForces(1).V2)/1000, V_col_theory/1000);

% 可视化
figure('Position', [100, 100, 1200, 800]);
subplot(2,3,1);
plot_deformation(nodes, elements, U, 100);
title('单层框架变形');

%% 案例2：单层双跨框架
fprintf('\n=== 案例2：单层双跨框架 ===\n');

% 节点坐标
nodes = [0 0; 0 3; 3 3; 6 3; 6 0];
% 单元属性
elements(1).type = 'beam'; elements(1).nodes = [1 2]; elements(1).prop_id = 1;
elements(2).type = 'beam'; elements(2).nodes = [2 3]; elements(2).prop_id = 2;
elements(3).type = 'beam'; elements(3).nodes = [3 4]; elements(3).prop_id = 2;
elements(4).type = 'beam'; elements(4).nodes = [4 5]; elements(4).prop_id = 1;

% 施加荷载
for e = 1:length(elements)
    L = norm(nodes(elements(e).nodes(2),:) - nodes(elements(e).nodes(1),:));
    if strcmp(elements(e).type, 'beam') && L > 2.9 % 只给横梁加荷载
        elements(e).udl = -4000; % 均布荷载 -4kN/m
    end
end

[K,F,dofpn] = assemble_global(nodes, elements, props);

% 边界条件
fixedDofs = [1, 2, 3, 13, 14, 15];
[Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
U = Km \ Fm;

fprintf('双跨框架最大挠度: %.6f m\n', max(abs(U([5,8,11]))));

subplot(2,3,2);
plot_deformation(nodes, elements, U, 100);
title('双跨框架变形');

%% 案例3：两层单跨框架
fprintf('\n=== 案例3：两层单跨框架 ===\n');

% 节点坐标
nodes = [0 0; 0 3; 3 3; 3 0; 0 6; 3 6];
% 单元属性
elements(1).type = 'beam'; elements(1).nodes = [1 2]; elements(1).prop_id = 1;
elements(2).type = 'beam'; elements(2).nodes = [2 3]; elements(2).prop_id = 2;
elements(3).type = 'beam'; elements(3).nodes = [3 4]; elements(3).prop_id = 1;
elements(4).type = 'beam'; elements(4).nodes = [2 5]; elements(4).prop_id = 1;
elements(5).type = 'beam'; elements(5).nodes = [5 6]; elements(5).prop_id = 2;
elements(6).type = 'beam'; elements(6).nodes = [6 3]; elements(6).prop_id = 1;

% 施加荷载
for e = 1:length(elements)
    L = norm(nodes(elements(e).nodes(2),:) - nodes(elements(e).nodes(1),:));
    if strcmp(elements(e).type, 'beam') && abs(L - 3) < 0.1 % 横梁
        elements(e).udl = -3000; % 均布荷载 -3kN/m
    end
end

[K,F,dofpn] = assemble_global(nodes, elements, props);

% 边界条件
fixedDofs = [1, 2, 3, 10, 11, 12];
[Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
U = Km \ Fm;

n_nodes = size(nodes, 1);
v_dofs = 2:3:(3*n_nodes);
fprintf('两层框架最大挠度: %.6f m\n', max(abs(U(v_dofs))));

subplot(2,3,3);
plot_deformation(nodes, elements, U, 100);
title('两层框架变形');

%% 案例4：水平荷载分析
fprintf('\n=== 案例4：水平荷载分析 ===\n');

% 重置荷载
for e = 1:length(elements)
    elements(e).udl = 0;
end

[K,F,dofpn] = assemble_global(nodes, elements, props);

% 施加水平荷载：顶层水平力
F(13) = -5000; % 水平力 -5kN

[Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
U = Km \ Fm;

h_dofs = 1:3:(3*n_nodes);
fprintf('水平荷载下最大位移: %.6f m\n', max(abs(U(h_dofs))));

subplot(2,3,4);
plot_deformation(nodes, elements, U, 100);
title('水平荷载变形');

%% 案例5：组合荷载分析
fprintf('\n=== 案例5：组合荷载分析 ===\n');

% 施加竖向和水平荷载
for e = 1:length(elements)
    L = norm(nodes(elements(e).nodes(2),:) - nodes(elements(e).nodes(1),:));
    if strcmp(elements(e).type, 'beam') && abs(L - 3) < 0.1 % 横梁
        elements(e).udl = -2000; % 均布荷载 -2kN/m
    end
end

[K,F,dofpn] = assemble_global(nodes, elements, props);

% 组合荷载
F(13) = -3000; % 顶层水平力 -3kN
F(16) = -2000; % 中层水平力 -2kN

[Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
U = Km \ Fm;

fprintf('组合荷载下最大位移: %.6f m\n', max(abs(U(h_dofs))));

subplot(2,3,5);
plot_deformation(nodes, elements, U, 100);
title('组合荷载变形');

%% 案例6：刚度对比分析
fprintf('\n=== 案例6：刚度对比分析 ===\n');

% 创建不同刚度的框架对比
I_values = [1e-5, 5e-5, 1e-4, 2e-4];
max_deflections = [];

for i = 1:length(I_values)
    % 使用案例1的框架，修改惯性矩
    props_mod = props;
    props_mod(1).I = I_values(i);
    props_mod(2).I = I_values(i);
    
    [K,F,dofpn] = assemble_global(nodes(1:4,:), elements(1:3), props_mod);
    
    % 施加均布荷载
    elements_mod = elements(1:3);
    for e = 1:length(elements_mod)
        elements_mod(e).udl = -2000;
    end
    
    [K,F,dofpn] = assemble_global(nodes(1:4,:), elements_mod, props_mod);
    
    % 边界条件
    fixedDofs = [1, 2, 3, 10, 11, 12];
    [Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
    U = Km \ Fm;
    
    max_deflections(i) = max(abs(U([5,8])));
end

% 绘制刚度-变形关系
subplot(2,3,6);
loglog(I_values, max_deflections, 'bo-', 'LineWidth', 2);
xlabel('截面惯性矩 I (m^4)'); ylabel('最大挠度 (m)');
title('刚度-变形关系');
grid on;

%% 总结
fprintf('\n=== 框架分析总结 ===\n');
fprintf('1. 单层框架：基础模型，易于理解和验证\n');
fprintf('2. 双跨框架：研究跨度增加的影响\n');
fprintf('3. 多层框架：模拟实际建筑结构\n');
fprintf('4. 水平荷载：研究侧向刚度\n');
fprintf('5. 组合荷载：模拟实际荷载工况\n');
fprintf('6. 刚度分析：理解刚度与变形的关系\n');
fprintf('\n该工具箱适用于建筑结构分析和设计教学。\n');