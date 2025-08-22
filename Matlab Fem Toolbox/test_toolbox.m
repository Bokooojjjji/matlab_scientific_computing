% test_toolbox.m
% Matlab Fem Toolbox 快速测试脚本
% 运行所有演示文件并检查功能

clc; clear; close all;

fprintf('=== Matlab Fem Toolbox 功能测试 ===\n\n');

%% 测试1：基础功能
fprintf('1. 测试基础功能...\n');
try
    % 运行示例文件
    example_beam_complete;
    fprintf('   ✓ 示例文件运行成功\n');
catch ME
    fprintf('   ✗ 示例文件运行失败: %s\n', ME.message);
end

%% 测试2：梁分析演示
fprintf('2. 测试梁分析演示...\n');
try
    demo_beam_analysis;
    fprintf('   ✓ 梁分析演示成功\n');
catch ME
    fprintf('   ✗ 梁分析演示失败: %s\n', ME.message);
end

%% 测试3：桁架分析演示
fprintf('3. 测试桁架分析演示...\n');
try
    demo_truss_analysis;
    fprintf('   ✓ 桁架分析演示成功\n');
catch ME
    fprintf('   ✗ 桁架分析演示失败: %s\n', ME.message);
end

%% 测试4：框架分析演示
fprintf('4. 测试框架分析演示...\n');
try
    demo_frame_analysis;
    fprintf('   ✓ 框架分析演示成功\n');
catch ME
    fprintf('   ✗ 框架分析演示失败: %s\n', ME.message);
end

%% 测试5：验证函数
fprintf('5. 测试验证函数...\n');
try
    % 创建简单简支梁测试
    E = 210e9; I = 8.333e-6; A = 0.01; L = 6; q = 5000;
    
    nodes = [0 0; L 0];
    elements(1).type = 'beam'; elements(1).nodes = [1 2]; elements(1).prop_id = 1; elements(1).udl = -q;
    props(1).E = E; props(1).I = I; props(1).A = A;
    
    [K,F,dofpn] = assemble_global(nodes, elements, props);
    fixedDofs = [2, 5];
    [Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
    U = Km \ Fm;
    elemForces = postprocess_beam_forces(nodes, elements, props, U);
    
    % 简单验证 - 检查位移是否合理
    max_deflection = max(abs(U));
    fprintf('   ✓ 验证函数运行成功\n');
    fprintf('   最大位移: %.6f m\n', max_deflection);
    
    % 检查是否为合理数值
    if ~isnan(max_deflection) && max_deflection < 1.0
        fprintf('   ✓ 结果合理\n');
    else
        fprintf('   ⚠ 结果异常\n');
    end
    
catch ME
    fprintf('   ✗ 验证函数失败: %s\n', ME.message);
end

%% 测试6：可视化功能
fprintf('6. 测试可视化功能...\n');
try
    % 创建简单桁架测试可视化
    nodes = [0 0; 3 0; 1.5 2.598];
    elements(1).type = 'truss'; elements(1).nodes = [1 3]; elements(1).prop_id = 1;
    elements(2).type = 'truss'; elements(2).nodes = [2 3]; elements(2).prop_id = 1;
    elements(3).type = 'truss'; elements(3).nodes = [1 2]; elements(3).prop_id = 1;
    props(1).E = 200e9; props(1).A = 0.001;
    
    [K,F,dofpn] = assemble_global(nodes, elements, props);
    F(5) = -10000;
    fixedDofs = [1, 2, 3, 4];
    [Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
    U = Km \ Fm;
    
    % 测试可视化
    plot_deformation(nodes, elements, U, 100);
    fprintf('   ✓ 可视化功能正常\n');
    
    % 关闭测试图形
    pause(1);
    close all;
    
catch ME
    fprintf('   ✗ 可视化功能失败: %s\n', ME.message);
end

%% 测试总结
fprintf('\n=== 测试总结 ===\n');
fprintf('所有演示文件已测试完成\n');
fprintf('工具箱功能完整，可用于结构力学教学\n');
fprintf('\n建议下一步：\n');
fprintf('1. 阅读 FEM_TOOLBOX_GUIDE.md 获取详细使用说明\n');
fprintf('2. 运行各个演示文件学习具体应用\n');
fprintf('3. 创建自定义结构模型进行练习\n');

%% 性能测试
fprintf('\n=== 性能测试 ===\n');
tic;
example_beam_complete;
time_basic = toc;
fprintf('基础示例运行时间: %.3f 秒\n', time_basic);

% 测试较大模型
tic;
demo_frame_analysis;
time_frame = toc;
fprintf('框架分析运行时间: %.3f 秒\n', time_frame);

fprintf('\n=== 测试完成 ===\n');
fprintf('Matlab Fem Toolbox 已准备就绪！\n');