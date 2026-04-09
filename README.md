# 2000-2026年全球大宗商品价格分析

## 项目概述

本项目对2000年至2026年全球主要商品的每日价格数据进行深入分析，包括**黄金、白银、原油、天然气、铜和铂**。

数据来源：[Kaggle - Global Commodity Prices 2000-2026](https://www.kaggle.com/datasets/ibrahimqasimi/global-commodity-prices-2000-2026)

## 分析方法

| 模块 | 内容 |
|------|------|
| **趋势分析** | 价格走势、年度/月度统计 |
| **周期性分析** | FFT频谱分析、季节性分解 |
| **相关性分析** | 商品间相关性、不同时期对比 |
| **波动性分析** | VaR风险价值、滚动波动率、极端事件 |
| **预测建模** | 线性回归、随机森林、XGBoost、集成学习 |

## 主要发现

### 季节性特征
- **所有商品均呈现年周期（12个月）**
- 原油季节性最强（7月高峰），贵金属季节性较弱

### 相关性
- **黄金-白银**：高度相关（0.941）
- **黄金-铜**：中高相关（0.834）
- **石油-天然气**：中度相关（0.611）

### 风险分析
- 使用VaR模型评估极端价格波动风险
- 计算不同置信区间的风险价值

## 技术栈

- **Python 3.x**
- pandas, numpy - 数据处理
- matplotlib, pyecharts - 可视化
- statsmodels - 时间序列分析
- scikit-learn - 机器学习建模
- xgboost - 梯度提升

## 文件结构

```
works/
├── project2.ipynb          # 完整分析代码
└── Global_Commodity_Prices_2000_2026.csv  # 数据文件
```

## 运行方式

```bash
# 在 Jupyter Notebook 中打开
jupyter notebook works/project2.ipynb

# 或在 JupyterLab 中
jupyter lab works/project2.ipynb
```

## 注意事项

- 代码中已修复季节性强度计算（使用方差法替代原始公式）
- 预测模型使用滚动预测避免数据泄露
- 所有分析均基于 Yahoo Finance 历史数据
