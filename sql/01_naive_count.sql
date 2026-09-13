-- Step 1: Naive count
-- Count all communication log rows for merchant 501
-- during October 2026 for communication type 2.

SELECT COUNT(*) AS naive_count
FROM communication_log
WHERE merchant_id = 501
  AND communication_type = '2'
  AND sent_time >= '2026-10-01'
  AND sent_time < '2026-11-01';