-- Step 3: Check for campaigns that have communication log rows
-- but have not cleared the approval workflow.

SELECT
    c.id AS campaign_id,
    c.name,
    c.creation_status,
    c.processing_status,
    COUNT(l.id) AS log_rows
FROM campaign c
LEFT JOIN communication_log l
    ON l.communication_id = c.id
WHERE c.merchant_id = 501
  AND c.name LIKE '%Diwali%'
  AND c.creation_status = 'approval_awaiting'
GROUP BY
    c.id,
    c.name,
    c.creation_status,
    c.processing_status
ORDER BY c.id;