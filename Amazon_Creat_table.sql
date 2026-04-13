
-- 创建数据库和表结构
-- 创建数据库
CREATE DATABASE AmazonDB;
GO

USE AmazonDB;
GO

--本次使用软件为SQL Server
--手动导入清洗后的数据，建立临时表Temp_Amazon。

-- 1. 分类表（Categories）：存储分类层级，用自增ID关联
CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_path NVARCHAR(500) NOT NULL UNIQUE 
);


-- 2. 用户表（Users）：存储用户ID和用户名（去重）
CREATE TABLE Users (
    user_id NVARCHAR(255) PRIMARY KEY,  -- 原始user_id是逗号分隔的字符串，需先拆分为单条记录
    user_name NVARCHAR(500) NOT NULL
);

SELECT DB_NAME() AS CurrentDatabase;--确定当前使用的是哪一个数据库

-- 3. 产品表（Products）：存储产品核心信息
CREATE TABLE Products (
    product_id NVARCHAR(50) PRIMARY KEY,
    product_name NVARCHAR(500) NOT NULL,
    category_id INT FOREIGN KEY REFERENCES Categories(category_id),
    discounted_price DECIMAL(10,2),
    actual_price DECIMAL(10,2),
    discount_percentage DECIMAL(5,2),
    rating DECIMAL(3,2),
    rating_count INT,
    about_product NVARCHAR(MAX),
    img_link NVARCHAR(500),
    product_link NVARCHAR(500)
);

-- 4. 评论表（Reviews）：存储评论信息，关联产品和用户
CREATE TABLE Reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id NVARCHAR(50) FOREIGN KEY REFERENCES Products(product_id),
    user_id NVARCHAR(255) FOREIGN KEY REFERENCES Users(user_id),
    review_title NVARCHAR(500),
    review_content NVARCHAR(MAX),
    review_date DATETIME DEFAULT GETDATE()  -- 若有日期字段可补充，原始数据无则默认当前时间
);

USE AmazonDB;
GO
INSERT INTO Categories (category_path)
SELECT DISTINCT category
FROM Temp_Amazon;
--填充分类表（Categories）,提取所有唯一的 category路径.

SELECT product_id, COUNT(*)
FROM Temp_Amazon
GROUP BY product_id
HAVING COUNT(*) > 1; --查看product_id是否有重复。结果有重复。
--product_id为产品表主键，应予以去重。


--填充产品表（Products）
--关联 category_id，清洗价格字段：

/*定义一个临时结果集 clean_temp，再用它做 INSERT*/
WITH clean_temp AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY product_id
               ORDER BY product_id
           ) AS rn
    FROM Temp_Amazon
)
INSERT INTO Products (
    product_id, product_name, category_id,
    discounted_price, actual_price, discount_percentage,
    rating, rating_count, about_product, img_link, product_link
)
SELECT 
    t.product_id,
    t.product_name,
    c.category_id,
    CAST(t.discounted_price AS decimal(10, 2)),
    CAST(t.actual_price AS decimal(10, 2)),
    CAST(REPLACE(t.discount_percentage,'%','') AS DECIMAL(5, 2)),
    CAST(t.rating AS DECIMAL(3, 2)),
    CAST(t.rating_count AS INT),
    t.about_product,
    t.img_link,
    t.product_link
FROM clean_temp t
INNER JOIN Categories c ON t.category = c.category_path
WHERE t.rn = 1;


--拆分用户和评论
INSERT INTO Users (user_id, user_name)
SELECT DISTINCT 
	 user_id,
	 user_name
FROM Temp_Amazon


--拆分评论（关联产品和用户）
-- 拆分评论ID、标题、内容，并关联产品和用户
-- 关联用户
INSERT INTO Reviews (
    product_id,
    user_id,
    review_title,
    review_content
)
SELECT 
    t.product_id,
    u.user_id,
    TRIM(rt.value),
    TRIM(rc.value)
FROM Temp_Amazon t
JOIN Users u 
    ON t.user_id LIKE '%' + u.user_id + '%' 
    --模糊匹配（Fuzzy Match）只要 Temp_Amazon.user_id中 包含​ Users.user_id，就认为匹配成功。
CROSS APPLY STRING_SPLIT(t.review_title, ',') rt
CROSS APPLY STRING_SPLIT(t.review_content, ',') rc
WHERE  
    TRIM(rt.value)!=''
    AND TRIM(rc.value)!='';