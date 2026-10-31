# Day 6 — SQL & PostgreSQL

**Name:** Polagani Harinadh Babu  
**Date:** 31 October 2026  
**Topic:** SQL & PostgreSQL

---

## Task 1: Design a Relational Database Schema

**Objective:** Create relational tables with appropriate constraints.

### Requirements
- Create `customers`, `products`, `orders` and `order_items` tables.
- Use primary keys and foreign keys.
- Apply `UNIQUE`, `NOT NULL`, `CHECK` and `DEFAULT` constraints.
- Use suitable data types.
- Use `NUMERIC` for exact monetary values.

## Task 2: Write SQL Queries for Filtering and Pagination

**Objective:** Retrieve, filter, sort and paginate records.

### Requirements
- Use `SELECT` and `WHERE` to retrieve records.
- Use `ORDER BY` for deterministic sorting.
- Implement pagination using `LIMIT` and `OFFSET`.
- Write a keyset pagination query using a stable cursor.
- Use parameterized queries for user-provided values.

### Example

```sql
SELECT order_id, amount
FROM orders
ORDER BY order_id
LIMIT 20 OFFSET 20;
```

## Task 3: Perform Joins and Subqueries

**Objective:** Retrieve related records from multiple tables.

### Requirements
- Use `INNER JOIN` to retrieve matching records.
- Use `LEFT JOIN` to include all customers, even those without orders.
- Use `NOT EXISTS` to find customers without orders.
- Use subqueries to filter related data.
- Avoid duplicate combinations when joining multiple child tables.

### Example

```sql
SELECT c.customer_id, c.full_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

## Task 4: Write Aggregate and Window Queries

**Objective:** Generate reports using aggregate functions and window functions.

### Requirements
- Use `COUNT`, `SUM`, `AVG`, `MIN` and `MAX`.
- Apply `GROUP BY` and `HAVING`.
- Use conditional aggregation.
- Create a CTE using `WITH`.
- Use `ROW_NUMBER()` to find each customer's latest order.
- Understand `RANK()`, `DENSE_RANK()`, `LAG()` and `LEAD()`.

### Example

```sql
WITH ranked_orders AS (
    SELECT order_id, customer_id, created_at,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY created_at DESC, order_id DESC
           ) AS row_num
    FROM orders
)
SELECT order_id, customer_id, created_at
FROM ranked_orders
WHERE row_num = 1;
```

## Task 5: Create SQLAlchemy Models and Manage Sessions

**Objective:** Map Python objects to database tables using SQLAlchemy 2.x.

### Requirements
- Create `Customer` and `Order` models.
- Define primary keys and foreign keys.
- Create relationships between customers and orders.
- Use sessions to manage database operations.
- Demonstrate `add()`, `commit()`, `rollback()` and `refresh()`.
- Explain the N+1 query problem and how `selectinload()` or `joinedload()` can reduce it.

## Task 6: Create and Apply Alembic Migrations

**Objective:** Manage database schema changes using Alembic.

### Requirements
- Install SQLAlchemy and Alembic.
- Initialize the migrations directory.
- Configure `target_metadata`.
- Generate and inspect a migration revision.
- Apply migrations using `alembic upgrade head`.
- Check the current revision and migration history.
- Explain upgrade, downgrade and multi-head migrations.

### Commands

```bash
alembic init migrations
alembic revision --autogenerate -m "add customer status"
alembic upgrade head
alembic current
alembic history
```

## Task 7: Optimise PostgreSQL Queries

**Objective:** Analyse query performance and use indexes appropriately.

### Requirements
- Create an index based on actual query patterns.
- Understand B-tree, GIN, GiST, BRIN and Hash indexes.
- Use `EXPLAIN ANALYZE` to inspect query performance.
- Compare estimated and actual rows.
- Inspect expensive scans and sorts.
- Measure performance before and after adding an index.
- Explain index storage and write-operation trade-offs.

### Example

```sql
CREATE INDEX idx_orders_customer_created
ON orders (customer_id, created_at DESC);

EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, amount
FROM orders
WHERE customer_id = 101
ORDER BY created_at DESC
LIMIT 20;
```

## Task 8: Configure PostgreSQL Connection Pooling

**Objective:** Manage database connections efficiently using `asyncpg`.

### Requirements
- Create an asynchronous PostgreSQL connection pool.
- Configure minimum and maximum pool sizes.
- Acquire connections using a context manager.
- Use parameterized queries with `$1` placeholders.
- Return connections to the pool after use.
- Handle transactions and rollbacks.
- Size the pool according to the database connection limit.

## Task 9: Complete the Assignment and Documentation

**Objective:** Prepare the project for submission with SQL scripts, model files and setup instructions.

### Requirements
- Create a folder named `Day 6-SQL-PostgreSQL`.
- Include SQL scripts for schema creation and queries.
- Include SQLAlchemy model files.
- Include an Alembic migration.
- Add a README with setup and run instructions.
- Include sample data and outputs.
- Add a schema diagram or relationship explanation.
- Document edge cases and design choices.
- Include a short query-plan explanation.
- Create a GitHub repository and add its URL to the submission form.

### Suggested Folder Structure

```text
Day 6-SQL-PostgreSQL/
├── README.md
├── requirements.txt
├── .env.example
├── .gitignore
├── sql/
│   ├── schema.sql
│   └── queries.sql
├── app/
│   ├── models.py
│   └── database.py
├── migrations/
│   ├── env.py
│   └── versions/
└── tests/
```

**Submission:** https://forms.gle/HSqpT6Mvy5GFh94g

**Deadline:** 31 October 2026, 11:59 PM.
