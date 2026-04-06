CREATE DATABASE zepto_analysis;

-- DATA EXPLORATION

-- VIEWING THE DATA
SELECT *
FROM zepto
LIMIT 10;

-- COUNT THE ROWS

SELECT COUNT(*)
FROM zepto;

-- LOOK FOR NULL  VALUES

SELECT *
FROM  zepto
WHERE category IS NULL
OR
name IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availableQuantity IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL
;

-- EXPLORE ALL CATEGORIES

SELECT DISTINCT category,COUNT(Category)
FROM zepto
GROUP BY category;

-- PRODUCT IN STOCK VS OUT OF STOCK

SELECT outOfStock, COUNT(outOfStock)
FROM zepto
GROUP BY outOfStock
;

-- PRODUCT NAMES THAT APPERAED MULTIPLE TIMES  

SELECT name , COUNT(name) AS multi_name
FROM zepto
GROUP BY name
HAVING multi_name >1
ORDER BY multi_name DESC;

-- DATA CLEANING

-- CHECK IF ANY PRODUCT HAS MRP AND DISCOUNTED PRICE OF ZERO

SELECT *
FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0 
   OR discountedSellingPrice = 0;
   
-- CHECKING IF DISCOUNTEDSELLINGPRICE > MRP

SELECT *
FROM zepto
WHERE discountedSellingPrice > mrp;

-- CONVERT MRP FROM PAISA TO RUPEE

ALTER TABLE zepto
ADD mrp_rupees FLOAT,
ADD dsp_rupees FLOAT;

UPDATE
zepto
SET mrp_rupees = (mrp/100),
dsp_rupees = (discountedsellingprice/100);

SELECT *
FROM zepto;

-- REAL WORLD PROBLEMS 

-- Q1. FIND THE TOP 10 BEST VALUE PRODUCTS BASED ON THE DISCOUNT PERCENTAGE

SELECT category,name,mrp_rupees,discountPercent,discountedSellingPrice
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10
;

-- Q2 . WHAT ARE THE PRODUCTS WITH HIGHER MRP AND OUT OF STOCK

SELECT name, mrp_rupees,outOfStock
FROM zepto
WHERE outOfStock = 'TRUE'
ORDER BY mrp_rupees DESC
LIMIT 5;

-- Q3. CALCULATE ESTIMATED REVENUE FOR EACH CATEGORY

SELECT DISTINCT category,
SUM(discountedSellingPrice * availableQuantity) AS estimated_revenue
FROM zepto
GROUP BY category;

-- Q4. FIND ALLL THE PRODUCTS WHERE MRP IS GREATER THAN 500 AND DISCOUNT IS LESS THAN 10%

SELECT name,mrp_rupees,discountPercent
FROM zepto
WHERE mrp_rupees > 500 and discountPercent <10
ORDER BY mrp_rupees desc ,discountPercent desc
;

-- Q5. IDENTIFY THE TOP 5 CATEGORIES OFFERING THE HIGHEST AVERAGE DISCOUNT

SELECT DISTINCT category, 
		AVG(discountPercent) AS avg_discount
FROM zepto 
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5
;

-- Q6. FIND THE PRICE PER GRAM OF THE PRODUCTS ABOBE 100G AND SORT BY THE BEST values

SELECT name,
ROUND(SUM(dsp_rupees / weightInGms),2) AS price_per_gram
FROM zepto
WHERE weightInGms > 100
GROUP BY name
ORDER BY price_per_gram 
LIMIT 10
;

-- Q7. GROUP THE PRODUCTS INTO CATEGORIES LIKE LOW,MEDIUM AND BULK BASED ON WEIGHT

SELECT  name,weightInGms,
CASE 
	WHEN weightInGms < 1000 THEN 'LOW'
    WHEN weightInGms < 5000 THEN 'MEDIUM'
    ELSE 'BULK'
    END AS weight_category
FROM zepto
;

-- Q8. WHAT IS THE TOTAL INVENTORY WEIGHT FOR THE CATEGORY

SELECT category,
SUM(availableQuantity * weightInGms) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;

