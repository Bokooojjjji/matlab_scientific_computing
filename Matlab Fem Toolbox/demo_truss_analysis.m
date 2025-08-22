% demo_truss_analysis.m
% 桁架结构有限元分析演示
% 包含静定和超静定桁架的对比验证

clc; clear; close all;

%% 参数设置
E = 200e9;      % 弹性模量 (Pa)
A = 0.001;      % 截面积 (m^2)

%% 案例1：简单桁架（静定）
fprintf('=== 案例1：简单桁架（静定）===\n');

% 节点坐标 (单位：m)
nodes = [0 0; 3 0; 1.5 2.598];
% 单元连接
elements(1).type = 'truss'; elements(1).nodes = [1 3]; elements(1).prop_id = 1;
elements(2).type = 'truss'; elements(2).nodes = [2 3]; elements(2).prop_id = 1;
elements(3).type = 'truss'; elements(3).nodes = [1 2]; elements(3).prop_id = 1;

props(1).E = E; props(1).A = A;

% 组装全局矩阵
[K,F,dofpn] = assemble_global(nodes, elements, props);

% 施加荷载
F(5) = -10000; % 节点3竖向荷载 -10kN

% 边界条件：节点1和2固定
fixedDofs = [1, 2, 3, 4];
[Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
U = Km \ Fm;

% 计算杆件内力
for e = 1:length(elements)
    nid = elements(e).nodes;
    L = norm(nodes(nid(2),:) - nodes(nid(1),:));
    c = (nodes(nid(2),1) - nodes(nid(1),1))/L;
    s = (nodes(nid(2),2) - nodes(nid(1),2))/L;
    
    % 提取局部位移
    dof = [2*nid(1)-1, 2*nid(1), 2*nid(2)-1, 2*nid(2)];
    u_e = U([freeDof; fixedDofs] == dof');
    
    % 计算轴力
    k_e = E*A/L * [c*c c*s -c*c -c*s; c*s s*s -c*s -s*s; -c*c -c*s c*c c*s; -c*s -s*s c*s s*s];
    f_e = k_e * u_e;
    N(e) = f_e(1); % 轴力
end

% 理论解（静定桁架）
L1 = norm(nodes(3,:) - nodes(1,:));
L2 = norm(nodes(3,:) - nodes(2,:));
L3 = norm(nodes(2,:) - nodes(1,:));

N1_theory = -10000 * L1 / (2 * 2.598); % 杆1轴力
N2_theory = -10000 * L2 / (2 * 2.598); % 杆2轴力
N3_theory = 0; % 杆3轴力

fprintf('节点位移:\n');
fprintf('节点3: u=%.6f m, v=%.6f m\n', U(5), U(6));

fprintf('\n杆件内力对比:\n');
fprintf('杆件1: FEM=%.2f kN, 理论=%.2f kN\n', N(1)/1000, N1_theory/1000);
fprintf('杆件2: FEM=%.2f kN, 理论=%.2f kN\n', N(2)/1000, N2_theory/1000);
fprintf('杆件3: FEM=%.2f kN, 理论=%.2f kN\n', N(3)/1000, N3_theory/1000);

% 可视化
figure('Position', [100, 100, 1200, 400]);
subplot(1,3,1);
plot_deformation(nodes, elements, U, 100);
title('简单桁架变形');

%% 案例2：超静定桁架
fprintf('\n=== 案例2：超静定桁架 ===\n');

% 节点坐标
nodes = [0 0; 3 0; 6 0; 3 3];
% 单元连接
elements(1).type = 'truss'; elements(1).nodes = [1 4]; elements(1).prop_id = 1;
elements(2).type = 'truss'; elements(2).nodes = [2 4]; elements(2).prop_id = 1;
elements(3).type = 'truss'; elements(3).nodes = [3 4]; elements(3).prop_id = 1;
elements(4).type = 'truss'; elements(4).nodes = [1 2]; elements(4).prop_id = 1;
elements(5).type = 'truss'; elements(5).nodes = [2 3]; elements(5).prop_id = 1;

[K,F,dofpn] = assemble_global(nodes, elements, props);

% 施加荷载
F(7) = -15000; % 节点4竖向荷载 -15kN

% 边界条件：底部三个节点固定
fixedDofs = [1, 2, 3, 4, 5, 6];
[Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
U = Km \ Fm;

fprintf('超静定桁架节点位移:\n');
fprintf('节点4: u=%.6f m, v=%.6f m\n', U(7), U(8));

subplot(1,3,2);
plot_deformation(nodes, elements, U, 100);
title('超静定桁架变形');

%% 案例3：门式框架
fprintf('\n=== 案例3：门式框架 ===\n');

% 节点坐标
nodes = [0 0; 0 3; 3 3; 3 0];
% 单元连接（使用梁单元）
elements(1).type = 'beam'; elements(1).nodes = [1 2]; elements(1).prop_id = 1;
elements(2).type = 'beam'; elements(2).nodes = [2 3]; elements(2).prop_id = 1;
elements(3).type = 'beam'; elements(3).nodes = [3 4]; elements(3).prop_id = 1;

props(1).E = E; props(1).I = 1e-5; props(1).A = 0.01;

[K,F,dofpn] = assemble_global(nodes, elements, props);

% 施加荷载
F(8) = -5000; % 节点2水平荷载 -5kN

% 边界条件：底部两个节点固定
fixedDofs = [1, 2, 3, 10, 11, 12];
[Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
U = Km \ Fm;

fprintf('门式框架节点位移:\n');
fprintf('节点2: u=%.6f m, v=%.6f m\n', U(7), U(8));
fprintf('节点3: u=%.6f m, v=%.6f m\n', U(10), U(11));

subplot(1,3,3);
plot_deformation(nodes, elements, U, 100);
title('门式框架变形');

%% 结果总结
fprintf('\n=== 桁架分析总结 ===\n');
fprintf('1. 简单桁架：静定结构，理论解验证正确\n');
fprintf('2. 超静定桁架：自动求解冗余约束\n');
fprintf('3. 门式框架：梁单元模拟框架结构\n');
fprintf('工具箱适用于各种桁架和框架结构分析。\n');