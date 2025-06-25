-- ==========================================
-- Restaurant Order Analysis (restaurant orders dataset from maven analytics)
-- ==========================================

-- 1 Total number of distinct orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM order_details;

-- 2 Total number of unique items ordered
SELECT COUNT(DISTINCT item_id) AS unique_items_ordered
FROM order_details;

-- 3 Top 5 highest-value orders (based on sum of item prices)
SELECT order_id, ROUND(SUM(price::NUMERIC), 2) AS total_order_value
FROM menu_item
JOIN order_details ON menu_item.menu_item_id = order_details.item_id
GROUP BY order_id
ORDER BY total_order_value DESC
LIMIT 5;

-- 4 Most and least ordered items
WITH least_ordered AS (
    SELECT item_name, COUNT(*) AS times_ordered
    FROM menu_item
    JOIN order_details ON menu_item_id = item_id
    GROUP BY item_name
    ORDER BY times_ordered ASC
    LIMIT 1
),
most_ordered AS (
    SELECT item_name, COUNT(*) AS times_ordered
    FROM menu_item
    JOIN order_details ON menu_item_id = item_id
    GROUP BY item_name
    ORDER BY times_ordered DESC
    LIMIT 1
)
SELECT * FROM least_ordered
UNION ALL
SELECT * FROM most_ordered;

-- 5 Average price per category
SELECT cat, COUNT(*) AS total_items, ROUND(AVG(price::NUMERIC), 2) AS avg_price
FROM menu_item
GROUP BY cat;

-- 6 Orders with 12 or more items
SELECT order_id, COUNT(*) AS item_count
FROM order_details
GROUP BY order_id
HAVING COUNT(*) >= 12;

-- 7 Total number of orders with 12 or more items
SELECT COUNT(*) FROM (
    SELECT order_id
    FROM order_details
    GROUP BY order_id
    HAVING COUNT(*) >= 12
) AS large_orders;

-- 8 Count of Italian dishes
SELECT COUNT(*) AS number_of_italian_dishes
FROM menu_item
WHERE cat ILIKE 'it%';

-- 9 Details of least and most expensive Italian dishes
(SELECT 'Least Expensive' AS label, item_name, price
 FROM menu_item
 WHERE cat ILIKE 'it%'
 ORDER BY price ASC LIMIT 1)
UNION ALL
(SELECT 'Most Expensive' AS label, item_name, price
 FROM menu_item
 WHERE cat ILIKE 'it%'
 ORDER BY price DESC LIMIT 1);

-- 10 Count of orders and items in one row
SELECT
  (SELECT COUNT(DISTINCT order_id) FROM order_details) AS total_orders,
  (SELECT COUNT(DISTINCT item_id) FROM order_details) AS total_items_ordered;

-- 11 Count of items ordered per category
SELECT item_name, menu_item.cat, COUNT(*) AS times_ordered
FROM menu_item
JOIN order_details ON menu_item_id = item_id
GROUP BY item_name, menu_item.cat
ORDER BY times_ordered;