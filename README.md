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

# 亚马逊销售数据集 SQL 分析项目

## 项目简介
本项目基于亚马逊印度站（amazon.in）电子产品销售数据，通过 Python 与 SQL 进行数据清洗、建模与分析，包含数据库创建、表结构设计、数据导入及多维分析查询。

## 数据库设计
采用关系型数据库设计，共 4 张核心表，通过外键关联：
- **Categories**：存储产品分类路径（自增主键 `category_id`）
- **Users**：存储用户 ID 与用户名（主键 `user_id`）
- **Products**：存储产品核心信息（主键 `product_id`，外键关联 `Categories`）
- **Reviews**：存储评论数据（自增主键 `review_id`，外键关联 `Products` 和 `Users`）

## 快速开始
1. **创建数据库与表**  
   执行 `SQLQuery1.sql` 中的 DDL 语句，创建 `AmazonDB` 数据库及 4 张表。
2. **导入数据**  
   - 将原始数据导入临时表 `Temp_Amazon`（需自行准备 CSV 导入）。
   - 执行 `SQLQuery1.sql` 中的 DML 语句，完成分类、产品、用户、评论数据填充。
3. **数据分析**  
   执行 `SQLQuery2.sql` 中的查询，获取价格分布、高折扣产品、评分分析等结果。

## 核心分析示例
- **价格分布统计**：按价格区间（0-200₹、201-500₹ 等）统计产品数量、平均评分与折扣率。
- **高折扣产品**：筛选折扣率 ≥50% 的产品，按折扣力度与评论数排序。
- **评分分布**：按评分区间（4.5-5.0、4.0-4.4 等）分析产品数量与价格特征。
- **高评价高销量产品**：筛选评分 ≥4.0 且评论数 ≥1000 的产品，综合排序推荐。

## 数据说明
- 数据来源：亚马逊印度站公开销售数据（amazon.in）https://www.kaggle.com/datasets/karkavelrajaj/amazon-sales-dataset
- 关键字段：产品 ID、名称、分类、折扣价、原价、评分、评论数、用户信息等
- 数据清洗：处理 `product_id` 重复、价格字段类型转换、评论多值拆分等

> 项目文件：  
> - `Amazon_Creat_table.sql`：数据库创建与数据导入  
> - `Amazon_query.sql`：数据分析查询
> - `Amazon_clean_copy`: 数据清洗
