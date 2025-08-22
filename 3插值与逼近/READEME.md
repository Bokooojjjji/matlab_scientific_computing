# Chapter 3 插值与逼近

## 📌 学习目标
- 掌握常见插值方法及其 MATLAB 实现
- 理解插值误差估计
- 熟悉分段插值与高次多项式的优缺点

## 📚 知识点
### 1. 多项式插值
- **Lagrange 插值**
- **Newton 插值**（差商公式）
- 插值误差估计

### 2. 分段插值
- 分段线性插值
- 三次样条插值（MATLAB: `spline`）

### 3. 高级逼近
- Hermite 插值（带导数条件）
- 正交多项式逼近（Chebyshev, Legendre）→ 建议了解

## 💻 MATLAB 实现
- `lagrange_interp.m`：Lagrange 插值函数
- `newton_interp.m`：Newton 插值函数
- `spline_demo.m`：样条插值示例