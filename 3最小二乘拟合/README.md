# Chapter 4 最小二乘拟合

## 📌 学习目标
- 理解最小二乘法原理
- 掌握多项式拟合与曲线拟合
- 使用 MATLAB `polyfit`, `polyval`, `fit`

## 📚 知识点
### 1. 多项式拟合
- 最小二乘原理：$\min ||Ax-b||_2$
- MATLAB: `polyfit(x,y,n)`

### 2. 曲线拟合
- 指数/幂函数/对数函数拟合
- 非线性最小二乘：`lsqcurvefit`

## 💻 MATLAB 实现
- `polyfit_demo.m`：多项式拟合
- `curvefit_demo.m`：指数曲线拟合