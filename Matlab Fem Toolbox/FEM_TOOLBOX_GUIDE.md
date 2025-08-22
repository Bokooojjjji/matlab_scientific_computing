# Matlab Fem Toolbox 使用指南

## 🎯 工具箱概述

Matlab Fem Toolbox 是一个专为结构力学教学设计的有限元分析工具箱，支持：
- **梁单元分析**：欧拉-伯努利梁理论
- **桁架单元分析**：二力杆理论
- **框架结构分析**：梁柱组合结构
- **多种边界条件**：简支、固支、自由等
- **多种荷载类型**：均布荷载、集中荷载、组合荷载

## 📁 文件结构

### 核心功能文件
- `beam_element.m` - 梁单元刚度矩阵
- `truss_element.m` - 桁架单元刚度矩阵
- `assemble_global.m` - 全局刚度矩阵组装
- `apply_boundary_conditions.m` - 边界条件处理
- `compute_udl_equivalent.m` - 均布荷载等效节点力
- `postprocess_beam_forces.m` - 单元内力计算
- `plot_deformation.m` - 变形可视化
- `validate_results.m` - 结果验证

### 演示文件
- `example_beam_complete.m` - 完整简支梁示例
- `demo_beam_analysis.m` - 梁结构分析演示
- `demo_truss_analysis.m` - 桁架结构分析演示
- `demo_frame_analysis.m` - 框架结构分析演示

## 🚀 快速开始

### 1. 运行演示文件
```matlab
% 运行梁分析演示
demo_beam_analysis

% 运行桁架分析演示
demo_truss_analysis

% 运行框架分析演示
demo_frame_analysis
```

### 2. 创建自定义分析

#### 简单简支梁
```matlab
% 定义参数
E = 210e9; I = 8.333e-6; A = 0.01; L = 6; q = 5000;

% 定义节点
nodes = [0 0; L 0];

% 定义单元
elements(1).type = 'beam';
elements(1).nodes = [1 2];
elements(1).prop_id = 1;
elements(1).udl = -q;

% 定义材料属性
props(1).E = E; props(1).I = I; props(1).A = A;

% 组装和求解
[K,F,dofpn] = assemble_global(nodes, elements, props);
fixedDofs = [2, 5]; % 简支边界
[Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
U = Km \ Fm;

% 后处理
elemForces = postprocess_beam_forces(nodes, elements, props, U);
plot_deformation(nodes, elements, U, 1000);
```

#### 简单桁架
```matlab
% 定义节点坐标
nodes = [0 0; 3 0; 1.5 2.598];

% 定义单元
elements(1).type = 'truss'; elements(1).nodes = [1 3]; elements(1).prop_id = 1;
elements(2).type = 'truss'; elements(2).nodes = [2 3]; elements(2).prop_id = 1;
elements(3).type = 'truss'; elements(3).nodes = [1 2]; elements(3).prop_id = 1;

% 定义属性
props(1).E = 200e9; props(1).A = 0.001;

% 组装和求解
[K,F,dofpn] = assemble_global(nodes, elements, props);
F(5) = -10000; % 节点荷载
fixedDofs = [1, 2, 3, 4]; % 底部固定
[Km,Fm,freeDof] = apply_boundary_conditions(K, F, fixedDofs);
U = Km \ Fm;

% 可视化
plot_deformation(nodes, elements, U, 100);
```

## 📊 结果验证

使用 `validate_results.m` 验证计算结果：

```matlab
% 准备验证参数
loads.udl = 5000;
loads.length = 6;

% 验证结果
[errors, theory] = validate_results('simply_supported', nodes, elements, props, U, elemForces, loads);

% 显示误差
fprintf('最大挠度误差: %.2f%%\n', errors.deflection);
fprintf('最大弯矩误差: %.2f%%\n', errors.moment);
```

## 🏗️ 结构类型支持

### 1. 梁结构
- **简支梁**：两端简支
- **悬臂梁**：一端固定
- **固端梁**：两端固定
- **连续梁**：多跨连续
- **外伸梁**：悬臂加简支

### 2. 桁架结构
- **简单桁架**：三角形组成
- **组合桁架**：多跨桁架
- **空间桁架**：三维桁架
- **塔架结构**：输电塔、通信塔

### 3. 框架结构
- **门式框架**：单层单跨
- **多层框架**：多层建筑
- **框架-剪力墙**：组合结构
- **工业厂房**：大跨度框架

## 📈 可视化功能

### 变形图
- 实时显示结构变形
- 支持变形放大系数
- 显示原始和变形后形状

### 内力图
- 弯矩图
- 剪力图
- 轴力图
- 支座反力

### 3D可视化
```matlab
% 创建3D视图
figure;
plot_deformation(nodes, elements, U, 100);
view(3); % 3D视角
```

## 🔧 高级功能

### 参数化分析
```matlab
% 刚度参数研究
I_values = logspace(-6, -3, 10);
deflections = [];

for I = I_values
    props(1).I = I;
    [K,F,dofpn] = assemble_global(nodes, elements, props);
    % ... 求解过程
    deflections(end+1) = max(abs(U([2,5])));
end

% 绘制刚度-变形关系
loglog(I_values, deflections);
```

### 荷载组合
```matlab
% 多种荷载组合
% 荷载1：均布荷载
elements(1).udl = -q1;
% 荷载2：集中荷载
F(5) = -P;
% 组合荷载
F_total = F_udl + F_point;
```

## 📚 教学应用

### 课程设计
1. **基础理论验证**：对比FEM与解析解
2. **参数敏感性分析**：研究刚度、荷载影响
3. **结构设计优化**：寻找最优截面
4. **工程案例模拟**：实际工程问题

### 实验对比
1. **材料力学实验**：梁弯曲试验
2. **结构试验**：框架加载试验
3. **数值模拟**：有限元分析

## 🎓 学习路径

### 初学者
1. 运行演示文件理解基本原理
2. 修改简单参数观察影响
3. 验证经典理论解

### 进阶学习
1. 创建复杂结构模型
2. 进行参数化分析
3. 研究收敛性和精度

### 高级应用
1. 开发新的单元类型
2. 实现动力分析功能
3. 集成优化算法

## ⚠️ 注意事项

### 单位系统
- 统一使用国际单位制（SI）
- 长度：米（m）
- 力：牛顿（N）
- 应力：帕斯卡（Pa）

### 边界条件
- 注意自由度编号
- 梁单元：3自由度/节点
- 桁架单元：2自由度/节点

### 荷载方向
- 竖向荷载：向下为负
- 水平荷载：向右为正
- 弯矩：顺时针为正

### 精度控制
- 单元数量影响精度
- 建议验证网格收敛性
- 使用 `validate_results` 验证

## 📞 技术支持

### 常见问题
1. **矩阵奇异**：检查边界条件是否充分
2. **结果异常**：验证荷载和约束
3. **可视化问题**：检查节点编号

### 调试建议
```matlab
% 检查刚度矩阵
spy(K); % 可视化矩阵结构

% 检查边界条件
fprintf('自由度总数: %d\n', size(K,1));
fprintf('约束自由度: %d\n', length(fixedDofs));

% 检查结果合理性
fprintf('最大位移: %.6f m\n', max(abs(U)));
```

---

*本工具箱专为结构力学教学开发，适合本科和研究生课程使用。*