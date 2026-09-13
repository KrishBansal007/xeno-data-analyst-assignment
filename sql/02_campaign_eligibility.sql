-- Step 2: Identify campaigns that are eligible for official reporting.
-- A campaign must have cleared creation approval and completed processing.

SELECT
    id,
    merchant_id,
    parent_id,
    name,
    creation_status,
    processing_status
FROM campaign
WHERE merchant_id = 501
  AND name LIKE '%Diwali%'
  AND creation_status IN ('approved', 'aborted', 'resumed', 'stopped')
  AND processing_status = 'processed'
ORDER BY id;