-- Step 4: Investigate retry chains.
-- Campaigns connected through parent_id represent the same
-- underlying communication and must not be counted multiple times.

SELECT
    c.id AS campaign_id,
    c.parent_id,
    c.name,
    c.creation_status,
    COUNT(l.id) AS log_rows,
    COUNT(DISTINCT l.customer_id) AS distinct_customers
FROM campaign c
LEFT JOIN communication_log l
    ON l.communication_id = c.id
WHERE c.merchant_id = 501
  AND c.name LIKE '%Diwali%'
GROUP BY
    c.id,
    c.parent_id,
    c.name,
    c.creation_status
ORDER BY c.id;