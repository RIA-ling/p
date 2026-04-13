USE AmazonDB
GO

-- 查看前5行数据
SELECT TOP 5 * FROM Products;
-- 或
/*SELECT * FROM Products LIMIT 5;  -- 如果使用MySQL/PostgreSQL*/

-- 查看数据基本信息
SELECT 
    COUNT(*) AS 总记录数,
    COUNT(DISTINCT product_id) AS 产品数,
    COUNT(DISTINCT category_id) AS 品类数,
    MIN(discounted_price) AS 最低售价,
    MAX(discounted_price) AS 最高售价
FROM Products;


-- 价格分布统计
SELECT 
    CASE 
        WHEN discounted_price <= 200 THEN '0-200₹' --单位为印度卢比
        WHEN discounted_price <= 500 THEN '201-500₹'
        WHEN discounted_price <= 1000 THEN '501-1000₹'
        WHEN discounted_price <= 2000 THEN '1001-2000₹'
        ELSE '2000₹+'
    END AS 价格区间,
    COUNT(*) AS 产品数量,
    AVG(rating) AS 平均评分,
    AVG(discount_percentage) AS 平均折扣率
FROM Products
WHERE discounted_price IS NOT NULL
GROUP BY 
    CASE 
        WHEN discounted_price <= 200 THEN '0-200₹'
        WHEN discounted_price <= 500 THEN '201-500₹'
        WHEN discounted_price <= 1000 THEN '501-1000₹'
        WHEN discounted_price <= 2000 THEN '1001-2000₹'
        ELSE '2000₹+'
    END
ORDER BY 价格区间;

-- 高折扣产品分析
SELECT TOP 10
    product_id,
    product_name,
    discounted_price,
    actual_price,
    discount_percentage,
    rating,
    rating_count
FROM Products
WHERE discount_percentage >= 50
ORDER BY discount_percentage DESC, rating_count DESC;

-- 折扣力度与评分的相关性
SELECT 
    CASE 
        WHEN discount_percentage < 30 THEN '低折扣(<30%)'
        WHEN discount_percentage < 50 THEN '中折扣(30-50%)'
        WHEN discount_percentage < 70 THEN '高折扣(50-70%)'
        ELSE '超高折扣(>70%)'
    END AS 折扣等级,
    COUNT(*) AS 产品数,
    AVG(rating) AS 平均评分,
    AVG(rating_count) AS 平均评论数
FROM Products
GROUP BY 
    CASE 
        WHEN discount_percentage < 30 THEN '低折扣(<30%)'
        WHEN discount_percentage < 50 THEN '中折扣(30-50%)'
        WHEN discount_percentage < 70 THEN '高折扣(50-70%)'
        ELSE '超高折扣(>70%)'
    END
ORDER BY 平均评分 DESC;

-- 评分分布统计
SELECT 
    CASE 
        WHEN rating >= 4.5 THEN '4.5-5.0'
        WHEN rating >= 4.0 THEN '4.0-4.4'
        WHEN rating >= 3.5 THEN '3.5-3.9'
        WHEN rating >= 3.0 THEN '3.0-3.4'
        ELSE '3.0以下'
    END AS 评分区间,
    COUNT(*) AS 产品数量,
    AVG(discounted_price) AS 区间平均价格,
    SUM(rating_count) AS 总评论数
FROM Products
WHERE rating IS NOT NULL
GROUP BY 
    CASE 
        WHEN rating >= 4.5 THEN '4.5-5.0'
        WHEN rating >= 4.0 THEN '4.0-4.4'
        WHEN rating >= 3.5 THEN '3.5-3.9'
        WHEN rating >= 3.0 THEN '3.0-3.4'
        ELSE '3.0以下'
    END
ORDER BY 评分区间 DESC;

-- 高评价高销量产品
SELECT TOP 20
    product_id,
    LEFT(product_name, 50) + '...' AS 产品名称,  -- 截断长名称
    discounted_price AS 售价,
    rating AS 评分,
    rating_count AS 评论数,
    discount_percentage AS 折扣率
FROM Products
WHERE rating >= 4.0 
    AND rating_count >= 1000
ORDER BY rating DESC, rating_count DESC;