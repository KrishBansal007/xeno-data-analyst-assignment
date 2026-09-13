# Comm-Log Send Reconciliation

## Overview

This project reconciles Finance's `target_base` metric for:

- Merchant: `501`
- Period: October 2026
- Campaign scope: Diwali campaigns
- Communication type: `2`

Finance's stated true `target_base` is **22**.

The analysis starts from the most naive communication-log count and progressively applies the business rules required to arrive at the correct figure.

## Final Result

**target_base = 22**

## Reconciliation Summary

| Step | Result | Explanation |
|---|---:|---|
| Naive communication-log count | 30 | Counts every matching communication-log row. |
| Exclude unapproved campaign 9004 | 26 | Campaign 9004 is `approval_awaiting`, so its 4 rows are not reportable. |
| Apply retry-chain deduplication | 20 | Customers across campaign/retry chains represent the same underlying communication. |
| Apply standalone send-event rule | **22** | Repeated sends within standalone campaign 9101 are separate events. |

## Final Breakdown

### Retry chain 9001 → 9002 → 9003

Distinct customers reached across the complete retry chain:

**10**

### Standalone campaign 9101

Send events:

**7**

C20 appears twice on different dates, and both sends count because 9101 is standalone.

### Retry chain 9201 → 9202

Distinct customers:

**5**

Therefore:

```text
10 + 7 + 5 = 22