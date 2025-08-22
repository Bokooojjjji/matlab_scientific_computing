# Chapter 6 常微分方程数值解法

## 📌 学习目标
- 理解欧拉法、改进欧拉法、四阶 Runge-Kutta 方法
- 熟悉 MATLAB 内置 ODE 求解器
- 掌握刚性问题与数值稳定性

## 📚 知识点
### 1. 基本方法
- 欧拉法：一阶精度
- 四阶 Runge-Kutta (RK4)：常用高精度算法

### 2. MATLAB ODE 求解器
- `ode45`：非刚性问题（中精度）
- `ode15s`：刚性问题

## 💻 MATLAB 实现
- `euler_method.m`：欧拉法
- `rk4_method.m`：四阶 Runge-Kutta
- `ode45_demo.m`：MATLAB 内置求解器