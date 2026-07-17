-- Retail Sales Analysis - P1
CREATE DATABASE SQL_PROJECT_1;

-- Create Table
DROP TABLE IF EXISTS RETAIL_SALES;

CREATE TABLE RETAIL_SALES (
	TRANSACTIONS_ID INT PRIMARY KEY,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(10),
	AGE INT,
	CATEGORY VARCHAR(15),
	QUANTIY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALE FLOAT
);

SELECT
	*
FROM
	RETAIL_SALES
LIMIT
	10;

SELECT
	COUNT(TRANSACTIONS_ID)
FROM
	RETAIL_SALES;

-- Data Cleaning
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL;

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY IS NULL;

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

DELETE FROM RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

-- Data Exploration
-- How many sales we have?
SELECT
	COUNT(*) AS TOTAL_SALES
FROM
	RETAIL_SALES;

-- How many Customers we have?
SELECT
	COUNT(DISTINCT CUSTOMER_ID)
FROM
	RETAIL_SALES;

-- How many categories we have?
SELECT DISTINCT
	CATEGORY
FROM
	RETAIL_SALES;

-- Data Analysis & Business key Problems and Answers
-- My Analysis and Findings
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022.
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
	AND QUANTITY >= 2;

;

ALTER TABLE RETAIL_SALES
RENAME COLUMN QUANTIY TO QUANTITY;

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	SUM(TOTAL_SALE),
	CATEGORY
FROM
	RETAIL_SALES
GROUP BY
	2;

SELECT
	*
FROM
	RETAIL_SALES;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(AGE), 2),
	CATEGORY
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty'
GROUP BY
	CATEGORY;

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT
	TRANSACTIONS_ID,
	TOTAL_SALE
FROM
	RETAIL_SALES
WHERE
	TOTAL_SALE > 1000
ORDER BY
	2;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	CATEGORY,
	GENDER,
	COUNT(TRANSACTIONS_ID)
FROM
	RETAIL_SALES
GROUP BY
	1,
	2;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT
	*
FROM
	(
		SELECT
			EXTRACT(
				YEAR
				FROM
					SALE_DATE
			) AS YEAR,
			EXTRACT(
				MONTH
				FROM
					SALE_DATE
			) AS MONTH,
			AVG(TOTAL_SALE),
			RANK() OVER (
				PARTITION BY
					EXTRACT(
						YEAR
						FROM
							SALE_DATE
					)
				ORDER BY
					AVG(TOTAL_SALE) DESC
			) AS RANK
		FROM
			RETAIL_SALES
		GROUP BY
			1,
			2
	) AS T1
WHERE
	RANK = 1
	-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT
	CUSTOMER_ID,
	SUM(TOTAL_SALE)
FROM
	RETAIL_SALES
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	COUNT(DISTINCT CUSTOMER_ID),
	CATEGORY
FROM
	RETAIL_SALES
GROUP BY
	2

	
	-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
WITH
	HOURLY_SALE AS (
		SELECT
			*,
			CASE
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) < 12 THEN 'morning'
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) BETWEEN 12 AND 17  THEN 'Afternoon'
				ELSE 'evening'
			END AS SHIFT
		FROM
			RETAIL_SALES
	)
SELECT
	COUNT(*),
	SHIFT
FROM
	HOURLY_SALE
GROUP BY
	SHIFT


																-- END OF PROJECT