import array
import os
import oracledb

with oracledb.connect(
    user=os.environ["ORACLE_USER"],
    password=os.environ["ORACLE_PASSWORD"],
    dsn=os.environ["ORACLE_DSN"]
) as conn:
    with conn.cursor() as cur:
        q_vec = array.array("f", [1.0, 0.0, 0.0])
        cur.execute(
            """
            SELECT id,
                   VECTOR_DISTANCE(embedding, :qv, COSINE) AS dist
            FROM   demo_vs26_docs
            WHERE  tenant_id = :tenant
            ORDER  BY dist
            FETCH EXACT FIRST 2 ROWS ONLY
            """,
            qv=q_vec,
            tenant=10
        )
        for row in cur:
            print(row)
