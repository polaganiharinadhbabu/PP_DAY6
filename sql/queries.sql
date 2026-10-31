
-- Sample customers
INSERT INTO customers (full_name, email)
VALUES
    ('Asha Rao', 'asha@example.com'),
    ('Ravi Kumar', 'ravi@example.com'),
    ('Priya Sharma', 'priya@example.com');

-- Sample products
INSERT INTO products (product_name, price)
VALUES
    ('Keyboard', 1200.00),
    ('Mouse', 500.00),
    ('Monitor', 8500.00);

-- Sample orders
INSERT INTO orders (customer_id, amount, status)
VALUES
    (1, 1700.00, 'PAID'),
    (1, 8500.00, 'NEW'),
    (2, 500.00, 'PAID');

-- Sample order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 1, 1200.00),
    (1, 2, 1, 500.00),
    (2, 3, 1, 8500.00),
    (3, 2, 1, 500.00);

-- 1. Retrieve customers
SELECT customer_id, full_name, email
FROM customers
ORDER BY customer_id;

-- 2. Filter orders
SELECT order_id, amount, status
FROM orders
WHERE amount >= 1000
ORDER BY created_at DESC, order_id DESC;

-- 3. Pagination
SELECT order_id, amount
FROM orders
ORDER BY order_id
LIMIT 20 OFFSET 0;

-- 4. Keyset pagination
SELECT order_id, amount
FROM orders
WHERE order_id > 10
ORDER BY order_id
LIMIT 20;

-- 5. Customers with orders
SELECT c.customer_id, c.full_name, o.order_id
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;

-- 6. All customers, including those without orders
SELECT c.customer_id, c.full_name, o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;

-- 7. Customers without orders
SELECT c.customer_id, c.full_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);

-- 8. Aggregate report
SELECT customer_id,
       COUNT(*) AS order_count,
       SUM(amount) AS total_spend,
       AVG(amount) AS average_order
FROM orders
WHERE status <> 'CANCELLED'
GROUP BY customer_id
HAVING COUNT(*) >= 1
ORDER BY total_spend DESC;

-- 9. CTE: total paid orders per customer
WITH customer_totals AS (
    SELECT customer_id, SUM(amount) AS total_spend
    FROM orders
    WHERE status = 'PAID'
    GROUP BY customer_id
)
SELECT customer_id, total_spend
FROM customer_totals
ORDER BY total_spend DESC;

-- 10. Latest order for each customer
WITH ranked_orders AS (
    SELECT order_id, customer_id, amount, created_at,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY created_at DESC, order_id DESC
           ) AS row_num
    FROM orders
)
SELECT order_id, customer_id, amount, created_at
FROM ranked_orders
WHERE row_num = 1;

-- 11. Find orders above the average amount
SELECT order_id, amount
FROM orders
WHERE amount > (
    SELECT AVG(amount) FROM orders
);
