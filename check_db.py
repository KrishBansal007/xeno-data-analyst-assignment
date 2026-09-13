import sqlite3

conn = sqlite3.connect("data/comm_log.db")

query = """
WITH RECURSIVE campaign_root AS (
    SELECT
        id AS campaign_id,
        id AS root_id
    FROM campaign

    UNION ALL

    SELECT
        cr.campaign_id,
        c.parent_id AS root_id
    FROM campaign_root cr
    JOIN campaign c
        ON c.id = cr.root_id
    WHERE c.parent_id IS NOT NULL
),

roots AS (
    SELECT
        campaign_id,
        root_id
    FROM campaign_root
    WHERE root_id IN (
        SELECT id
        FROM campaign
        WHERE parent_id IS NULL
    )
),

eligible_campaigns AS (
    SELECT
        c.id,
        c.name,
        c.parent_id,
        r.root_id,

        CASE
            WHEN c.parent_id IS NOT NULL
              OR EXISTS (
                  SELECT 1
                  FROM campaign child
                  WHERE child.parent_id = c.id
              )
            THEN 1
            ELSE 0
        END AS is_retry_chain

    FROM campaign c
    JOIN roots r
        ON r.campaign_id = c.id

    WHERE c.merchant_id = 501
      AND c.name LIKE '%Diwali%'
      AND c.creation_status IN (
          'approved',
          'aborted',
          'resumed',
          'stopped'
      )
      AND c.processing_status = 'processed'
),

retry_chain_counts AS (
    SELECT
        e.root_id,
        COUNT(DISTINCT l.customer_id) AS qualifying_sends

    FROM eligible_campaigns e
    JOIN communication_log l
        ON l.communication_id = e.id

    WHERE e.is_retry_chain = 1
      AND l.merchant_id = 501
      AND l.communication_type = '2'
      AND l.sent_time >= '2026-10-01'
      AND l.sent_time < '2026-11-01'

    GROUP BY e.root_id
),

standalone_counts AS (
    SELECT
        e.id AS campaign_id,
        COUNT(l.id) AS qualifying_sends

    FROM eligible_campaigns e
    JOIN communication_log l
        ON l.communication_id = e.id

    WHERE e.is_retry_chain = 0
      AND l.merchant_id = 501
      AND l.communication_type = '2'
      AND l.sent_time >= '2026-10-01'
      AND l.sent_time < '2026-11-01'

    GROUP BY e.id
)

SELECT
    (
        SELECT COALESCE(SUM(qualifying_sends), 0)
        FROM retry_chain_counts
    )
    +
    (
        SELECT COALESCE(SUM(qualifying_sends), 0)
        FROM standalone_counts
    ) AS target_base;
"""

result = conn.execute(query).fetchone()[0]

print("Final target_base:", result)

conn.close()