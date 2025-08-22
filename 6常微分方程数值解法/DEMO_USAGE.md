# 常微分方程数值解法演示文件使用指南

## 📋 文件列表

### 基础演示文件
1. **demo_euler_detailed.m** - 欧拉法详细演示
   - 包含误差分析和收敛性研究
   - 展示步长对精度的影响
   - 适合初学者理解欧拉法原理

2. **demo_rk4_comparison.m** - RK4方法与欧拉法对比
   - 对比欧拉法、改进欧拉法、RK4方法
   - 包含简谐振子和洛伦兹吸引子两个经典问题
   - 展示不同方法的精度和稳定性

3. **demo_stiff_equations.m** - 刚性方程演示
   - 对比ode45和ode15s在处理刚性问题时的差异
   - 包含Van der Pol振荡器和Robertson化学反应模型
   - 展示刚性问题的特点和求解策略

4. **demo_ode_comprehensive.m** - 综合演示
   - 包含5种数值方法和3个测试问题
   - 全面的误差分析和效率对比
   - 适合作为教学演示

5. **demo_classical_problems.m** - 经典问题演示
   - 5个经典ODE问题的数值解法
   - 简谐振子、阻尼振动、范德波尔振荡器、洛伦兹系统、捕食者-猎物系统
   - 物理和生物系统的应用实例

## 🚀 快速开始

### 运行单个演示
```matlab
% 运行欧拉法详细演示
demo_euler_detailed

% 运行RK4对比演示
demo_rk4_comparison

% 运行刚性方程演示
demo_stiff_equations

% 运行综合演示
demo_ode_comprehensive

% 运行经典问题演示
demo_classical_problems
```

### 批量运行所有演示
```matlab
% 运行所有演示文件
demo_files = {'demo_euler_detailed', 'demo_rk4_comparison', ...
              'demo_stiff_equations', 'demo_ode_comprehensive', ...
              'demo_classical_problems'};

for i = 1:length(demo_files)
    fprintf('\n=== 运行 %s ===\n', demo_files{i});
    eval(demo_files{i});
    pause(2); % 暂停2秒查看结果
end
```

## 📊 演示内容详解

### 1. 欧拉法演示 (demo_euler_detailed.m)
- **测试问题**: dy/dx = y - x² + 1, y(0) = 0.5
- **精确解**: y(x) = x² + 2x + 1 - 0.5eˣ
- **展示内容**:
  - 不同步长的数值解对比
  - 全局误差分析
  - 收敛性研究（O(h)）
  - 计算效率分析

### 2. RK4对比演示 (demo_rk4_comparison.m)
- **测试问题1**: 简谐振子 y'' + y = 0
- **测试问题2**: 洛伦兹吸引子
- **对比方法**: 欧拉法、改进欧拉法、RK4、ode45
- **分析维度**:
  - 时间序列对比
  - 相空间轨迹
  - 能量守恒分析
  - 精度对比

### 3. 刚性方程演示 (demo_stiff_equations.m)
- **Van der Pol振荡器**: 不同μ值（1, 10, 100, 1000）
- **Robertson化学反应**: 刚性化学系统
- **对比方法**: ode45 vs ode15s
- **关键指标**:
  - 计算步数
  - 计算时间
  - 数值稳定性

### 4. 综合演示 (demo_ode_comprehensive.m)
- **测试问题**:
  1. 一阶线性方程
  2. 阻尼振动系统
  3. Logistic增长模型
- **数值方法**:
  1. 欧拉法
  2. 改进欧拉法
  3. RK4
  4. ode45
  5. ode15s
- **分析内容**:
  - 解的对比
  - 误差分析
  - 计算效率
  - 收敛性研究

### 5. 经典问题演示 (demo_classical_problems.m)
- **简谐振子**: 能量守恒、周期性
- **阻尼振动**: 衰减行为
- **范德波尔振荡器**: 极限环、非线性动力学
- **洛伦兹系统**: 混沌、蝴蝶效应
- **捕食者-猎物系统**: 生态平衡、周期性振荡

## 🔧 自定义使用

### 修改测试问题
每个演示文件都允许轻松修改测试问题：

```matlab
% 例如，在demo_euler_detailed.m中修改
f = @(x,y) 你的微分方程;
y_exact = @(x) 你的精确解;
a = 起始点; b = 终点; h = 步长;
y(1) = 初始条件;
```

### 添加新的数值方法
基于现有模板添加新的数值方法：

```matlab
function [t,Y] = 你的方法(f, tspan, y0, h)
    % 实现你的数值方法
end
```

### 调整可视化参数
修改图形显示参数：

```matlab
% 调整图形大小
figure('Position', [x, y, width, height]);

% 修改线条样式
plot(x, y, 'r--', 'LineWidth', 2, 'MarkerSize', 8);

% 调整子图布局
subplot(rows, cols, index);
```

## 📈 学习建议

### 初学者路径
1. 先运行 `demo_euler_detailed.m` 理解欧拉法
2. 然后运行 `demo_rk4_comparison.m` 了解精度差异
3. 最后运行 `demo_ode_comprehensive.m` 获得全面认识

### 进阶学习
1. 研究 `demo_stiff_equations.m` 了解刚性问题
2. 探索 `demo_classical_problems.m` 中的物理应用
3. 尝试修改参数和添加新问题

### 教学使用
- 每个演示文件都可以独立运行
- 包含详细的注释和解释
- 适合课堂演示和学生自学

## 🎯 预期结果

运行这些演示文件后，你应该能够：

1. **理解基本原理**: 掌握各种数值方法的工作原理
2. **比较方法性能**: 了解不同方法的优缺点
3. **分析误差来源**: 识别数值误差的类型和来源
4. **选择合适方法**: 根据问题特点选择最佳数值方法
5. **应用于实际问题**: 将数值方法应用到工程和科学问题中

## 📞 技术支持

如果在使用过程中遇到问题：

1. 检查MATLAB版本兼容性（需要R2016b或更高版本）
2. 确保所有依赖文件都在同一目录下
3. 查看命令窗口的错误信息
4. 逐步调试单个演示文件

---

*这些演示文件由常微分方程数值解法课程设计，适合教学和研究使用。*