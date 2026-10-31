
import asyncio
import os

import asyncpg
from dotenv import load_dotenv

load_dotenv()


async def main():
    database_url = os.getenv("DATABASE_URL")

    if not database_url:
        raise RuntimeError("DATABASE_URL is missing")

    dsn = database_url.replace(
        "postgresql+psycopg://", "postgresql://", 1
    )

    pool = await asyncpg.create_pool(
        dsn=dsn,
        min_size=2,
        max_size=10,
    )

    try:
        async with pool.acquire() as connection:
            row = await connection.fetchrow(
                "SELECT customer_id, full_name "
                "FROM customers WHERE customer_id = $1",
                1,
            )
            print(row)
    finally:
        await pool.close()


if __name__ == "__main__":
    asyncio.run(main())
