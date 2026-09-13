-- Step 5: Investigate standalone campaigns.
-- For a standalone communication, every send is its own event,
-- even when the same customer appears more than once.

SELECT
    c.id AS campaign_id,
    c.name,
    COUNT(l.id) AS send_rows,
    COUNT(DISTINCT l.customer_id) AS distinct_customers
FROM campaign c
JOIN communication_log l
    ON l.communication_id = c.id
WHERE c.merchant_id = 501
  AND c.name LIKE '%Diwali%'
  AND c.parent_id IS NULL
  AND NOT EXISTS (
      SELECT 1
      FROM campaign child
      WHERE child.parent_id = c.id
  )
GROUP BY
    c.id,
    c.name
ORDER BY c.id;